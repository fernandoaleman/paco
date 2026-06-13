-- Window rules. Properties are set directly as keys (no "rule" field);
-- `match` filters which windows the rule applies to.
-- Reference: https://wiki.hypr.land/Configuring/Basics/Window-Rules/

-- Suppress apps trying to programmatically maximize themselves —
-- conflicts with Hyprland's tiling.
hl.window_rule({
  match = { class = ".*" },
  suppress_event = "maximize",
})
