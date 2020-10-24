local AddOnName, AddOn = ...
local L = AddOn.L

AddOn.DB = LibMan1:Get("LibDatabase", 1):New(AddOnName, "CountIt_DB", L.DEFAULT)
local DB = AddOn.DB

DB:SetDefault(LibStub("LibSharedMedia-3.0"):GetDefault(LibStub("LibSharedMedia-3.0").MediaType.FONT), "appearance",
              "font")
DB:SetDefault(14, "appearance", "height")
DB:SetDefault(false, "appearance", "outline")
DB:SetDefault(false, "appearance", "shadow")
DB:SetDefault(1, "appearance", "scale")
DB:SetDefault(1, "appearance", "color", "r")
DB:SetDefault(1, "appearance", "color", "g")
DB:SetDefault(1, "appearance", "color", "b")
DB:SetDefault(1, "appearance", "color", "a")
DB:SetDefault(false, "visibility", "showMax")
DB:SetDefault(false, "visibility", "hideIfMax")
DB:SetDefault(0, "visibility", "threshold")
DB:SetDefault(false, "visibility", "mouseOver")
DB:SetDefault(true, "visibility", "cooldown", "hide")
DB:SetDefault(1.5, "visibility", "cooldown", "threshold")
DB:SetDefault("LEFT", "position", "point")
DB:SetDefault(2, "position", "ofsx")
DB:SetDefault(0, "position", "ofsy")

DB:SetDefault(true, "visibility", "ignoredSpells", 81) -- Dodge
DB:SetDefault(true, "visibility", "ignoredSpells", 6603) -- Attack
DB:SetDefault(true, "visibility", "ignoredSpells", 5019) -- Shoot
DB:SetDefault(true, "visibility", "ignoredSpells", 20592) -- Arcane Resistance
DB:SetDefault(true, "visibility", "ignoredSpells", 20574) -- Axe Specialization
DB:SetDefault(true, "visibility", "ignoredSpells", 20557) -- Beast Slaying
DB:SetDefault(true, "visibility", "ignoredSpells", 26296) -- Berserking
DB:SetDefault(true, "visibility", "ignoredSpells", 20554) -- Berserking
DB:SetDefault(true, "visibility", "ignoredSpells", 26297) -- Berserking
DB:SetDefault(true, "visibility", "ignoredSpells", 20572) -- Blood Fury
DB:SetDefault(true, "visibility", "ignoredSpells", 26290) -- Bow Specialization
DB:SetDefault(true, "visibility", "ignoredSpells", 20577) -- Cannibalize
DB:SetDefault(true, "visibility", "ignoredSpells", 20575) -- Command
DB:SetDefault(true, "visibility", "ignoredSpells", 20552) -- Cultivation
DB:SetDefault(true, "visibility", "ignoredSpells", 20599) -- Diplomacy
DB:SetDefault(true, "visibility", "ignoredSpells", 20550) -- Endurance
DB:SetDefault(true, "visibility", "ignoredSpells", 20593) -- Engineering Specialization
DB:SetDefault(true, "visibility", "ignoredSpells", 20589) -- Escape Artist
DB:SetDefault(true, "visibility", "ignoredSpells", 20591) -- Expansive Mind
DB:SetDefault(true, "visibility", "ignoredSpells", 2481) -- Find Treasure
DB:SetDefault(true, "visibility", "ignoredSpells", 20596) -- Frost Resistance
DB:SetDefault(true, "visibility", "ignoredSpells", 20595) -- Gun Specialization
DB:SetDefault(true, "visibility", "ignoredSpells", 20573) -- Hardiness
DB:SetDefault(true, "visibility", "ignoredSpells", 20864) -- Mace Specialization
DB:SetDefault(true, "visibility", "ignoredSpells", 20551) -- Nature Resistance
DB:SetDefault(true, "visibility", "ignoredSpells", 20583) -- Nature Resistance
DB:SetDefault(true, "visibility", "ignoredSpells", 20600) -- Perception
DB:SetDefault(true, "visibility", "ignoredSpells", 20582) -- Quickness
DB:SetDefault(true, "visibility", "ignoredSpells", 20555) -- Regeneration
DB:SetDefault(true, "visibility", "ignoredSpells", 20579) -- Shadow Resistance
DB:SetDefault(true, "visibility", "ignoredSpells", 20580) -- Shadowmeld
DB:SetDefault(true, "visibility", "ignoredSpells", 20594) -- Stoneform
DB:SetDefault(true, "visibility", "ignoredSpells", 20597) -- Sword Specialization
DB:SetDefault(true, "visibility", "ignoredSpells", 20598) -- The Human Spirit
DB:SetDefault(true, "visibility", "ignoredSpells", 20558) -- Throwing Specialization
DB:SetDefault(true, "visibility", "ignoredSpells", 5227) -- Underwater Breathing
DB:SetDefault(true, "visibility", "ignoredSpells", 20549) -- War Stomp
DB:SetDefault(true, "visibility", "ignoredSpells", 7744) -- Will of the Forsaken
DB:SetDefault(true, "visibility", "ignoredSpells", 20585) -- Wisp Spirit
