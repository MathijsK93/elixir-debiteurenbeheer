workflow "New workflow" {
  on = "push"
  resolves = ["Mathijs Kingma"]
}

action "Mathijs Kingma" {
  uses = "actions/npm@59b64a598378f31e49cb76f27d6f3312b582f680"
  runs = "Mathijs Kingma"
  args = "run ci"
  secrets = ["GITHUB_TOKEN"]
}
