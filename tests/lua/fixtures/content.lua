-- Synthetic, license-safe metadata shapes modeled on BeamNG 0.38.6 registry,
-- slots/slots2, variables, configuration, and partsTree structures.
return {
  models = {
    {key = "official_simple", Name = "Fixture Simple", Source = "BeamNG - Official", Type = "Car"},
    {key = "official_deep", Name = "Fixture Deep", Source = "BeamNG - Official", Type = "Truck"},
    {key = "mod_complete", Name = "Fixture Mod Vehicle", modID = "fixture_mod", Source = "Fixture Mod", Type = "Car"},
    {key = "unknown_vehicle", Name = "Fixture Unknown", Source = "Community Label", Type = "Unknown"},
    {key = "automation_vehicle", Name = "Fixture Automation", Source = "BeamNG - Official", Type = "Automation"},
    {key = "trailer_vehicle", Name = "Fixture Trailer", Source = "BeamNG - Official", Type = "Trailer"},
    {key = "prop_vehicle", Name = "Fixture Prop", Source = "BeamNG - Official", Type = "Prop"},
  },
  configs = {
    {model_key = "official_simple", key = "official_base", Source = "BeamNG - Official", pcFilename = "/vehicles/official_simple/official_base.pc"},
    {model_key = "official_simple", key = "pack_config", Source = "Fixture Pack", modID = "fixture_pack", pcFilename = "/vehicles/official_simple/pack_config.pc"},
    {model_key = "official_simple", key = "saved_config", Source = "Custom", player = true, pcFilename = "/vehicles/official_simple/saved_config.pc"},
    {model_key = "mod_complete", key = "mod_base", modID = "fixture_mod", pcFilename = "/vehicles/mod_complete/mod_base.pc"},
    {model_key = "unknown_vehicle", key = "unknown_base", Source = "Community Label", pcFilename = "/vehicles/unknown_vehicle/unknown_base.pc"},
    {model_key = "automation_vehicle", key = "automation_base", Source = "BeamNG - Official", pcFilename = "/vehicles/automation_vehicle/base.pc"},
    {model_key = "trailer_vehicle", key = "trailer_base", Source = "BeamNG - Official", pcFilename = "/vehicles/trailer_vehicle/base.pc"},
    {model_key = "prop_vehicle", key = "prop_base", Source = "BeamNG - Official", pcFilename = "/vehicles/prop_vehicle/base.pc"},
    {model_key = "official_simple", Source = "BeamNG - Official"},
  },
  legacySlots = {
    {"type", "default", "description"},
    {"fixture_engine", "fixture_engine_base", "Engine", {coreSlot = true}},
  },
  slots2 = {
    {"name", "allowTypes", "denyTypes", "default", "description"},
    {"fixture_energy", {"fixture_battery"}, {}, "fixture_battery_base", "Energy Storage", {required = true}},
  },
  nestedTree = {
    chosenPartName = "fixture_root",
    children = {
      engine = {
        id = "engine", path = "/engine/", chosenPartName = "engine_a",
        suitablePartNames = {"engine_a", "engine_b"},
        children = {
          intake = {
            id = "intake", path = "/engine/intake/", chosenPartName = "intake_a",
            suitablePartNames = {"intake_a", "intake_stale"}, children = {},
          },
        },
      },
      suspension = {
        id = "suspension", path = "/suspension/", chosenPartName = "suspension_a",
        suitablePartNames = {"suspension_a", "suspension_b"},
        children = {
          hub = {
            id = "hub", path = "/suspension/hub/", chosenPartName = "hub_a",
            suitablePartNames = {"hub_a", "hub_b"},
            children = {
              wheel = {
                id = "wheel", path = "/suspension/hub/wheel/", chosenPartName = "wheel_a",
                suitablePartNames = {"wheel_a", "wheel_pack_b"},
                children = {
                  tire = {
                    id = "tire", path = "/suspension/hub/wheel/tire/", chosenPartName = "tire_a",
                    suitablePartNames = {"tire_a", "tire_pack_b"}, children = {},
                  },
                },
              },
            },
          },
        },
      },
      accessory = {
        id = "accessory", path = "/accessory/", chosenPartName = "accessory_a",
        suitablePartNames = {"accessory_a", "part_pack_b"}, children = {},
      },
    },
  },
  electricMetadata = {
    ["/energy/"] = {required = true, defaultPart = "battery_a", description = "Energy Storage", allowTypes = {"battery"}},
    ["/motor/"] = {required = true, defaultPart = "motor_a", description = "Electric Motor", allowTypes = {"motor"}},
  },
  multiDifferentialTree = {
    chosenPartName = "root",
    children = {
      frontDifferential = {id = "frontDifferential", path = "/frontDifferential/", chosenPartName = "front_diff_a", suitablePartNames = {"front_diff_a"}, children = {}},
      centerDifferential = {id = "centerDifferential", path = "/centerDifferential/", chosenPartName = "center_diff_a", suitablePartNames = {"center_diff_a"}, children = {}},
      rearDifferential = {id = "rearDifferential", path = "/rearDifferential/", chosenPartName = "rear_diff_a", suitablePartNames = {"rear_diff_a"}, children = {}},
    },
  },
  variables = {
    independentA = {min = 0, max = 10, default = 5, step = 1},
    independentB = {min = -1, max = 1, default = 0, stepDis = 0.1},
    groupedA = {min = 0, max = 100, default = 50, step = 5, correlationGroup = "explicit_axle", correlationStrategy = "shared_normalized_sample"},
    groupedB = {min = 10, max = 20, default = 15, step = 2, correlationGroup = "explicit_axle", correlationStrategy = "shared_normalized_sample"},
    nameLooksPairedFront = {min = 0, max = 1, default = 0.5},
    nameLooksPairedRear = {min = 0, max = 1, default = 0.5},
    malformed = {min = "low", max = 10, default = {}},
  },
  paints = {
    one = {{baseColor = {0.2, 0.3, 0.4, 1}}},
    three = {
      {baseColor = {0.2, 0.3, 0.4, 1}},
      {baseColor = {0.4, 0.3, 0.2, 1}},
      {baseColor = {0.1, 0.5, 0.7, 1}},
    },
  },
}
