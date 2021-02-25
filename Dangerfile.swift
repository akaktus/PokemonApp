import Danger 
let danger = Danger()

report = xcov.produce_report(
  scheme: 'PockemonApp',
  workspace: 'Pockemon/PockemonApp.xcworkspace',
  exclude_targets: 'Pods.app',
  minimum_coverage_percentage: 75
)

xcov.output_report(report)
