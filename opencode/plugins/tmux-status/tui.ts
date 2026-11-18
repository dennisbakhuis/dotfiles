// opencode TUI plugin: mirror this TUI's session state onto its tmux pane, the
// same way the Claude Code hooks do, so the tmux status bar shows a mark per
// window. It reuses scripts/claude-tmux-status.sh with TMUX_AGENT=opencode,
// which makes tmux underline the mark (see @agent_glyphs in tmux/tmux.conf).
//
// Installed by symlinking this folder to ~/.config/opencode/plugins/tmux-status.
// It runs in the TUI process (not the background server) because only the TUI
// knows which tmux pane it lives in.
import { Plugin } from "@opencode/plugin/tui"
import { spawn } from "node:child_process"
import { homedir } from "node:os"
import { join } from "node:path"

const SCRIPT = join(homedir(), "dotfiles/scripts/claude-tmux-status.sh")

type State = "permission" | "question" | "running" | "error" | "stopped"

const SCRIPT_CALL: Record<State, [event: string, reason?: string]> = {
  permission: ["notify", "permission_prompt"],
  question: ["notify", "question"],
  running: ["prompt"],
  error: ["error"],
  stopped: ["stop"],
}

const TRANSITIONS: Record<string, State> = {
  "session.execution.started": "running",
  "session.execution.succeeded": "stopped",
  "session.execution.interrupted": "stopped",
  "session.execution.failed": "error",
  "permission.asked": "permission",
  "permission.replied": "running",
  "form.created": "question",
  "form.replied": "running",
  "form.cancelled": "running",
}

let queue: Promise<void> = Promise.resolve()

function report(event: string, reason?: string) {
  queue = queue.then(
    () =>
      new Promise<void>((resolve) => {
        const child = spawn("bash", [SCRIPT, event], {
          env: { ...process.env, TMUX_AGENT: "opencode" },
          stdio: ["pipe", "ignore", "ignore"],
        })
        child.on("error", () => resolve())
        child.on("close", () => resolve())
        child.stdin.end(reason ? JSON.stringify({ notification_type: reason }) : "")
      }),
  )
}

export default Plugin.define({
  id: "local.tmux-status",
  setup(context) {
    if (!process.env.TMUX_PANE) return

    const sessions = new Map<string, State>()
    let shown: State | undefined

    // Every TUI hears the events of every session on the shared server, so only
    // follow sessions that were on screen here, plus their subagent sessions.
    const ownerOf = (sessionID: string): string | undefined => {
      if (sessions.has(sessionID)) return sessionID
      const route = context.ui.router.current() as { sessionID?: string } | undefined
      if (route?.sessionID === sessionID) return sessionID
      const rootID = context.data.session.root(sessionID) as string | undefined
      if (rootID && rootID !== sessionID && (sessions.has(rootID) || route?.sessionID === rootID)) return rootID
      return undefined
    }

    const publish = (latest: State) => {
      const states = [...sessions.values()]
      const next =
        (["permission", "question", "running"] as State[]).find((state) => states.includes(state)) ?? latest
      if (next === shown) return
      shown = next
      report(...SCRIPT_CALL[next])
    }

    report("start")
    const stop = context.data.listen((event: any) => {
      const details = event?.details
      const state = TRANSITIONS[details?.type]
      const sessionID = details?.data?.sessionID
      if (!state || !sessionID) return
      const owner = ownerOf(sessionID)
      if (!owner) return
      const isChild = owner !== sessionID
      if (isChild && details.type.startsWith("session.execution.")) return
      if (details.type.endsWith(".replied") || details.type === "form.cancelled") {
        const current = sessions.get(owner)
        if (current !== "permission" && current !== "question") return
      }
      sessions.set(owner, state)
      publish(state)
    })

    return () => {
      stop()
      report("end")
    }
  },
})
