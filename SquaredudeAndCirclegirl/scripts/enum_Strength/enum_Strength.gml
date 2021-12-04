
enum Strength {
  // Weakest; breaks nothing
  PlayerFlying = 0,
  // Breaks cracked blocks but doesn't push crates
  PlayerRunning = 1,
  // Breaks cracked blocks and pushes crates
  Block = 2,
}