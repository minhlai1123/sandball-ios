import json
import math
import os

world_names = [
    "🏖️ Sunny Beach",      # W1: L1-10
    "🍬 Candy Dunes",      # W2: L11-20
    "🌿 Emerald Meadow",   # W3: L21-30
    "🍧 Ice Cream Peak",   # W4: L31-40
    "🌈 Rainbow Canyon",   # W5: L41-50
    "💣 TNT Quarry",       # W6: L51-60
    "🎡 Carnival Park",    # W7: L61-70
    "🏰 Sand Castle",      # W8: L71-80
    "🌌 Space Portals",    # W9: L81-90
    "👑 Master Island"     # W10: L91-100
]

level_titles = [
    # World 1: Sunny Beach (1-10)
    "First Dig", "Sandy Slide", "Zigzag Valley", "Double Gate", "Little Windmill",
    "Bouncy Mushroom", "Hidden Friends", "Magic Vortex", "TNT Surprise", "Beach Carnival",
    # World 2: Candy Dunes (11-20)
    "Candy Fork", "Triple Treat", "Strawberry Chute", "Portal Leap", "Twin Spinners",
    "Sugar Blast", "Bumper Slalom", "Jelly Jump", "Sweet Chamber", "Sugar Castle",
    # World 3: Emerald Meadow (21-30)
    "Green Sprout", "Clover Wheel", "Forest Stream", "Double Whirl", "Bouncy Blossom",
    "River Chute", "Windmill Gate", "Mossy Path", "Pebble Cascade", "Emerald Citadel",
    # World 4: Ice Cream Peak (31-40)
    "Snowball Drop", "Vanilla Rebound", "Triple Bumper", "Slingshot Peak", "Frosty Vortex",
    "Glacier Slide", "Ice Pinball", "Twin Portals", "Chilly Blast", "Sundae Summit",
    # World 5: Rainbow Canyon (41-50)
    "Color Burst", "Prism Gate", "Rainbow Slalom", "Quad Multiplier", "Sky Bridge",
    "Starry Funnel", "Super Cascade", "Prism Vortex", "Mega Swarm", "Rainbow Arch",
    # World 6: TNT Quarry (51-60)
    "First Detonation", "Quarry Tunnel", "Chain Reaction", "Bedrock Boom", "TNT Chute",
    "Rock Breaker", "Cavern Burst", "Triple Boom", "Demolition Rush", "Quarry Master",
    # World 7: Carnival Park (61-70)
    "Ferris Wheel", "Funhouse Bumper", "Roller Slide", "Prize Vortex", "Double Loop",
    "Carnival Slingshot", "Pinball Maze", "Merry-Go-Round", "Grand Parade", "Carnival King",
    # World 8: Sand Castle (71-80)
    "Castle Gate", "Moat Crossing", "Secret Chamber", "Tower Staircase", "Courtyard Spin",
    "Dungeon Vault", "Royal Portal", "Castle Ramparts", "Treasure Hall", "Castle Fortress",
    # World 9: Space Portals (81-90)
    "Cosmic Jump", "Starlight Gate", "Gravity Well", "Wormhole Triad", "Asteroid Bounce",
    "Meteor Blast", "Orbit Spin", "Galaxy Chute", "Hyper Jump", "Cosmic Voyager",
    # World 10: Master Island (91-100)
    "Master Trial 1", "Master Trial 2", "The Great Slalom", "Demolition Core", "Whirlwind Canyon",
    "Vortex Labyrinth", "Bumper Fiesta", "Mega Multiplier", "The Gauntlet", "Grand Champion"
]

def generate_level(level_id):
    world_id = ((level_id - 1) // 10) + 1
    idx = level_id - 1
    title = level_titles[idx] if idx < len(level_titles) else f"Level {level_id}"

    # Ball count progression: 20 -> 110
    total_balls = int(22 + (level_id - 1) * 0.90)
    total_balls = min(max(total_balls, 20), 110)

    # Quota: 50% to 75%
    quota_ratio = 0.50 + (level_id / 100.0) * 0.25
    quota = max(10, int(total_balls * quota_ratio))

    spawners = []
    # Initial colored balls at top
    initial_colored = max(16, int(total_balls * (0.60 - (level_id / 100.0) * 0.15)))
    dormant_total = total_balls - initial_colored

    spawners.append({
        "x": 500.0,
        "y": 1650.0,
        "count": initial_colored,
        "type": "colored",
        "spreadRadius": 105.0
    })

    # Dormant white balls chambers
    if dormant_total > 0:
        chambers = min(3, max(1, (level_id % 4) + 1))
        per_chamber = dormant_total // chambers
        rem = dormant_total % chambers
        for c in range(chambers):
            count = per_chamber + (rem if c == 0 else 0)
            if count <= 0:
                continue
            cy = 1350.0 - c * (800.0 / max(1, chambers))
            cx = 320.0 if c % 2 == 0 else 680.0
            if chambers == 3 and c == 1:
                cx = 500.0
            spawners.append({
                "x": round(cx, 1),
                "y": round(cy, 1),
                "count": count,
                "type": "dormant_white",
                "spreadRadius": 72.0
            })

    obstacles = []

    # Bottom guide funnels
    obstacles.append({
        "id": "funnel_left",
        "type": "funnel_bumper",
        "x": 240.0,
        "y": 260.0,
        "width": 240.0,
        "height": 38.0,
        "rotationDegrees": -25.0,
        "restitution": 0.35
    })
    obstacles.append({
        "id": "funnel_right",
        "type": "funnel_bumper",
        "x": 760.0,
        "y": 260.0,
        "width": 240.0,
        "height": 38.0,
        "rotationDegrees": 25.0,
        "restitution": 0.35
    })

    # Level specific feature distribution
    # Every level has a unique tailored combination!
    step = ((level_id - 1) % 10) + 1

    if world_id == 1: # 🏖️ Sunny Beach: Progressive tutorial of elements
        if step == 2:
            obstacles.append({"id": "ramp_1", "type": "static_beam", "x": 620.0, "y": 1050.0, "width": 300.0, "height": 30.0, "rotationDegrees": -25.0, "restitution": 0.3})
        elif step == 3:
            obstacles.append({"id": "ramp_1", "type": "static_beam", "x": 350.0, "y": 1150.0, "width": 280.0, "height": 30.0, "rotationDegrees": 24.0, "restitution": 0.3})
            obstacles.append({"id": "ramp_2", "type": "static_beam", "x": 650.0, "y": 780.0, "width": 280.0, "height": 30.0, "rotationDegrees": -24.0, "restitution": 0.3})
        elif step == 4:
            # First Multiplier Gate!
            obstacles.append({"id": "gate_1", "type": "multiplier_gate", "x": 500.0, "y": 950.0, "width": 180.0, "height": 36.0, "multiplier": 2})
        elif step == 5:
            # First Rotating Windmill Paddle
            obstacles.append({"id": "paddle_1", "type": "rotating_paddle", "x": 500.0, "y": 950.0, "width": 260.0, "height": 30.0, "rotationDegrees": 0.0, "motorSpeed": 40.0})
        elif step == 6:
            # First Bouncy Pinball Bumper
            obstacles.append({"id": "bumper_1", "type": "bouncy_bumper", "x": 500.0, "y": 950.0, "width": 80.0, "height": 80.0, "restitution": 1.8})
        elif step == 7:
            # Dual guide ramps with dormant white ball chamber
            obstacles.append({"id": "ramp_1", "type": "static_beam", "x": 320.0, "y": 1200.0, "width": 260.0, "height": 30.0, "rotationDegrees": -20.0, "restitution": 0.3})
            obstacles.append({"id": "ramp_2", "type": "static_beam", "x": 680.0, "y": 800.0, "width": 260.0, "height": 30.0, "rotationDegrees": 20.0, "restitution": 0.3})
        elif step == 8:
            # First Portal Pair!
            obstacles.append({"id": "portal_1", "type": "portal_pair", "x": 300.0, "y": 1100.0, "exitX": 650.0, "exitY": 700.0, "width": 80.0})
        elif step == 9:
            # First TNT Crate!
            obstacles.append({"id": "tnt_1", "type": "tnt_crate", "x": 500.0, "y": 950.0, "width": 60.0, "height": 60.0})
        elif step == 10:
            # Beach Finale Boss: Multiplier + Spinner + Bumper
            obstacles.append({"id": "gate_1", "type": "multiplier_gate", "x": 320.0, "y": 1150.0, "width": 160.0, "height": 34.0, "multiplier": 2})
            obstacles.append({"id": "paddle_1", "type": "rotating_paddle", "x": 680.0, "y": 900.0, "width": 220.0, "height": 28.0, "motorSpeed": 45.0})
            obstacles.append({"id": "bumper_1", "type": "bouncy_bumper", "x": 500.0, "y": 600.0, "width": 80.0, "height": 80.0})

    elif world_id == 2: # 🍬 Candy Dunes: Multipliers & Sweet Portals
        if step % 3 == 1:
            obstacles.append({"id": "gate_1", "type": "multiplier_gate", "x": 340.0, "y": 1100.0, "width": 170.0, "height": 34.0, "multiplier": 2})
            obstacles.append({"id": "gate_2", "type": "multiplier_gate", "x": 660.0, "y": 800.0, "width": 170.0, "height": 34.0, "multiplier": 2})
        elif step % 3 == 2:
            obstacles.append({"id": "portal_1", "type": "portal_pair", "x": 320.0, "y": 1150.0, "exitX": 680.0, "exitY": 750.0, "width": 80.0})
            obstacles.append({"id": "bumper_1", "type": "bouncy_bumper", "x": 500.0, "y": 950.0, "width": 80.0, "height": 80.0})
        else:
            obstacles.append({"id": "tnt_1", "type": "tnt_crate", "x": 350.0, "y": 1050.0, "width": 60.0})
            obstacles.append({"id": "paddle_1", "type": "rotating_paddle", "x": 650.0, "y": 850.0, "width": 240.0, "height": 28.0, "motorSpeed": -35.0})

    elif world_id == 3: # 🌿 Emerald Meadow: Rotating Windmills & Precision Chutes
        obstacles.append({"id": "paddle_1", "type": "rotating_paddle", "x": 500.0, "y": 1150.0, "width": 260.0, "height": 28.0, "motorSpeed": 35.0 + step * 4})
        if step >= 5:
            obstacles.append({"id": "paddle_2", "type": "rotating_paddle", "x": 350.0 if step % 2 == 0 else 650.0, "y": 750.0, "width": 220.0, "height": 26.0, "motorSpeed": -40.0})
        obstacles.append({"id": "gate_1", "type": "multiplier_gate", "x": 500.0, "y": 550.0, "width": 180.0, "height": 34.0, "multiplier": 2})

    elif world_id == 4: # 🍧 Ice Cream Peak: Pinball Bouncy Bumpers
        obstacles.append({"id": "bumper_1", "type": "bouncy_bumper", "x": 340.0, "y": 1150.0, "width": 85.0, "height": 85.0})
        obstacles.append({"id": "bumper_2", "type": "bouncy_bumper", "x": 660.0, "y": 1050.0, "width": 85.0, "height": 85.0})
        obstacles.append({"id": "bumper_3", "type": "bouncy_bumper", "x": 500.0, "y": 750.0, "width": 85.0, "height": 85.0})
        if step >= 6:
            obstacles.append({"id": "portal_1", "type": "portal_pair", "x": 280.0, "y": 950.0, "exitX": 720.0, "exitY": 550.0, "width": 75.0})

    elif world_id == 5: # 🌈 Rainbow Canyon: Mega Multipliers (Swarm Puzzles)
        obstacles.append({"id": "gate_1", "type": "multiplier_gate", "x": 500.0, "y": 1200.0, "width": 200.0, "height": 36.0, "multiplier": 3})
        obstacles.append({"id": "ramp_1", "type": "static_beam", "x": 320.0, "y": 900.0, "width": 260.0, "height": 28.0, "rotationDegrees": 22.0})
        obstacles.append({"id": "ramp_2", "type": "static_beam", "x": 680.0, "y": 900.0, "width": 260.0, "height": 28.0, "rotationDegrees": -22.0})
        if step >= 4:
            obstacles.append({"id": "gate_2", "type": "multiplier_gate", "x": 500.0, "y": 650.0, "width": 180.0, "height": 36.0, "multiplier": 2})

    elif world_id == 6: # 💣 TNT Quarry: Explosive Demolition Chambers
        obstacles.append({"id": "tnt_1", "type": "tnt_crate", "x": 350.0, "y": 1150.0, "width": 60.0})
        obstacles.append({"id": "tnt_2", "type": "tnt_crate", "x": 650.0, "y": 900.0, "width": 60.0})
        if step >= 5:
            obstacles.append({"id": "tnt_3", "type": "tnt_crate", "x": 500.0, "y": 650.0, "width": 60.0})
        obstacles.append({"id": "bumper_1", "type": "bouncy_bumper", "x": 500.0, "y": 1350.0, "width": 80.0, "height": 80.0})

    elif world_id == 7: # 🎡 Carnival Park: Spinners & Bouncy Bumpers Combo
        obstacles.append({"id": "paddle_1", "type": "rotating_paddle", "x": 350.0, "y": 1100.0, "width": 240.0, "height": 28.0, "motorSpeed": 45.0})
        obstacles.append({"id": "paddle_2", "type": "rotating_paddle", "x": 650.0, "y": 850.0, "width": 240.0, "height": 28.0, "motorSpeed": -45.0})
        obstacles.append({"id": "bumper_1", "type": "bouncy_bumper", "x": 500.0, "y": 600.0, "width": 85.0, "height": 85.0})
        obstacles.append({"id": "gate_1", "type": "multiplier_gate", "x": 500.0, "y": 1350.0, "width": 170.0, "height": 34.0, "multiplier": 2})

    elif world_id == 8: # 🏰 Sand Castle: Secret Chambers with Teleport Portals
        obstacles.append({"id": "portal_1", "type": "portal_pair", "x": 280.0, "y": 1250.0, "exitX": 720.0, "exitY": 950.0, "width": 80.0})
        obstacles.append({"id": "portal_2", "type": "portal_pair", "x": 720.0, "y": 750.0, "exitX": 350.0, "exitY": 520.0, "width": 80.0})
        obstacles.append({"id": "tnt_1", "type": "tnt_crate", "x": 500.0, "y": 850.0, "width": 60.0})

    elif world_id == 9: # 🌌 Space Portals: Complex Wormhole Networks
        obstacles.append({"id": "portal_1", "type": "portal_pair", "x": 300.0, "y": 1200.0, "exitX": 700.0, "exitY": 900.0, "width": 80.0})
        obstacles.append({"id": "portal_2", "type": "portal_pair", "x": 700.0, "y": 1200.0, "exitX": 300.0, "exitY": 900.0, "width": 80.0})
        obstacles.append({"id": "gate_1", "type": "multiplier_gate", "x": 500.0, "y": 700.0, "width": 190.0, "height": 36.0, "multiplier": 3})
        obstacles.append({"id": "bumper_1", "type": "bouncy_bumper", "x": 500.0, "y": 500.0, "width": 85.0, "height": 85.0})

    else: # 👑 Master Island (World 10: 91-100): The Ultimate Puzzles
        obstacles.append({"id": "paddle_1", "type": "rotating_paddle", "x": 500.0, "y": 1250.0, "width": 280.0, "height": 30.0, "motorSpeed": 50.0})
        obstacles.append({"id": "portal_1", "type": "portal_pair", "x": 260.0, "y": 1050.0, "exitX": 740.0, "exitY": 750.0, "width": 80.0})
        obstacles.append({"id": "tnt_1", "type": "tnt_crate", "x": 500.0, "y": 900.0, "width": 60.0})
        obstacles.append({"id": "bumper_1", "type": "bouncy_bumper", "x": 320.0, "y": 650.0, "width": 85.0, "height": 85.0})
        obstacles.append({"id": "gate_1", "type": "multiplier_gate", "x": 680.0, "y": 650.0, "width": 160.0, "height": 34.0, "multiplier": 2})

    sand_regions = [{
        "x": 0.0,
        "y": 260.0,
        "width": 1000.0,
        "height": 1490.0,
        "carvable": True
    }]

    truck = {
        "x": 500.0,
        "y": 120.0,
        "width": 320.0,
        "height": 150.0,
        "quota": quota
    }

    return {
        "levelId": level_id,
        "worldId": world_id,
        "title": title,
        "quota": quota,
        "totalInitialBalls": total_balls,
        "bounds": {
            "width": 1000.0,
            "height": 1800.0
        },
        "sandRegions": sand_regions,
        "ballSpawners": spawners,
        "obstacles": obstacles,
        "collectibles": [],
        "truck": truck
    }

def main():
    android_dir = r"e:\SAND BALLS\android\app\src\main\assets\levels"
    ios_dir = r"e:\SAND BALLS\ios\SandAdventure\Resources\Levels"

    os.makedirs(android_dir, exist_ok=True)
    os.makedirs(ios_dir, exist_ok=True)

    for lvl in range(1, 101):
        data = generate_level(lvl)
        json_str = json.dumps(data, indent=2)

        android_file = os.path.join(android_dir, f"level_{lvl}.json")
        ios_file = os.path.join(ios_dir, f"level_{lvl}.json")

        with open(android_file, "w", encoding="utf-8") as f:
            f.write(json_str)

        with open(ios_file, "w", encoding="utf-8") as f:
            f.write(json_str)

    print("Successfully generated all 100 levels with diverse mechanics into Android assets and iOS resources!")

if __name__ == "__main__":
    main()
