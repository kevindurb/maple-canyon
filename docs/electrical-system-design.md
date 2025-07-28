# Electrical System Design

## System Overview

### Power Architecture
- **Primary Power**: EcoFlow River III Portable Power Station
- **Backup Power**: None (EcoFlow has built-in battery)
- **Shore Power**: Pass-through charging for EcoFlow
- **Solar Power**: Pass-through charging for EcoFlow
- **Distribution**: All 12V DC from EcoFlow outputs

### EcoFlow River III Specifications
- **Battery**: 288Wh LiFePO4
- **AC Output**: 600W (1200W surge)
- **12V DC Output**: 10A max (120W)
- **USB-A Output**: 5V/2.4A × 3 ports
- **USB-C Output**: 5V-20V/3A × 1 port
- **Input**: AC + Solar simultaneous charging
- **Weight**: 17.8 lbs

## Power Distribution System

### EcoFlow Mounting & Access
```
HEADBOARD STORAGE - CENTER SECTION
┌─────────────────────────────────────┐
│            ECOFLOW CABINET          │
│  ┌─────────────────────────────┐    │ 12" Deep
│  │                             │    │
│  │        ECOFLOW RIVER III    │    │ 24" Wide  
│  │        (11.4" × 7.3" × 8.3")│    │
│  │                             │    │ 20" High
│  │  Ventilation gaps all sides │    │
│  └─────────────────────────────┘    │
│                                     │
│  Cable pass-through to exterior ────┼── To exterior inputs
│  Internal power distribution ───────┼── To interior loads
└─────────────────────────────────────┘
```

### Power Input System
```
EXTERIOR POWER PANEL (Passenger Side)
┌──────────────────────────────────────┐
│        POWER INPUT PANEL             │
│                                      │
│  ┌────────────┐  ┌────────────────┐  │
│  │ SHORE      │  │ SOLAR PANEL    │  │
│  │ POWER      │  │ INPUT          │  │
│  │ INPUT      │  │ MC4 Connector  │  │
│  │ NEMA 5-15  │  │                │  │
│  └────────────┘  └────────────────┘  │
│       │                   │         │
│       └─────────┬─────────┘         │
│                 │                   │
│    Weather-proof pass-through       │
│         to interior                 │
└──────────────────────────────────────┘
                   │
         ┌────────────────────┐
         │ INTERIOR CABLES    │
         │ to EcoFlow Unit    │
         └────────────────────┘
```

## Load Distribution

### Interior Lighting Circuit
| Light Location | Type | Power | Connection | Control |
|----------------|------|-------|------------|---------|
| Left Reading Light | LED Spot | 3W | 12V DC | Wall Switch |
| Right Reading Light | LED Spot | 3W | 12V DC | Wall Switch |
| Left Entry Light | LED | 5W | 12V DC | Light Switch |
| Right Entry Light | LED | 5W | 12V DC | Light Switch |
| Tongue Light | LED | 5W | 12V DC | Light Switch |
| **Total Lighting** | | **21W** | | |

### USB Charging Distribution
| Location | Ports | Type | Power Each | Total |
|----------|-------|------|------------|-------|
| Left Headboard | 2-3 | USB-A | 2.4A/12W | 24-36W |
| Right Headboard | 2-3 | USB-A | 2.4A/12W | 24-36W |  
| Left Foot Cabinet | 2 | USB-A | 2.4A/12W | 24W |
| Right Foot Cabinet | 2 | USB-A | 2.4A/12W | 24W |
| **Total USB** | **8-10** | | | **96-120W** |

### MaxxFan Ventilation
| Component | Type | Power | Connection | Control |
|-----------|------|-------|------------|---------|
| MaxxFan | 12V Fan | 36W (3A) | 12V DC | Variable Speed |

### Total System Load
| Circuit | Normal Use | Peak Use | Notes |
|---------|------------|----------|-------|
| Lighting | 6-12W | 21W | Not all lights on simultaneously |
| USB Charging | 24-48W | 120W | Depends on devices connected |
| MaxxFan | 12-24W | 36W | Variable speed control |
| **System Total** | **42-84W** | **177W** | Well within EcoFlow capacity |

## Wiring Specifications

### Wire Gauge & Routing
| Circuit | Wire Gauge | Length | Route | Protection |
|---------|------------|--------|-------|------------|
| Main 12V Feed | 12 AWG | 8 feet | EcoFlow to Distribution | 15A Fuse |
| Lighting Branch | 16 AWG | 12 feet | To each light | 5A Fuse |
| USB Branch | 14 AWG | 10 feet | To each USB hub | 10A Fuse |
| MaxxFan | 12 AWG | 6 feet | Direct to fan | 5A Fuse |
| External Inputs | 14 AWG | 4 feet | Pass-through only | N/A |

### Distribution Panel
```
12V DISTRIBUTION (Inside Headboard)
┌────────────────────────────────────┐
│         FUSE BLOCK                 │
│                                    │
│  ┌──┐ ┌──┐ ┌──┐ ┌──┐ ┌──┐        │
│  │15│ │5A│ │10│ │5A│ │15│        │
│  │A │ │  │ │A │ │  │ │A │        │
│  └┬─┘ └┬─┘ └┬─┘ └┬─┘ └┬─┘        │
│   │    │    │    │    │           │
│ Main Light USB  Fan Shore/Solar   │
└───┼────┼────┼────┼────┼───────────┘
    ↓    ↓    ↓    ↓    ↓
  To EcoFlow 12V Output
```

## Circuit Details

### Reading Light Circuit
```
EcoFlow 12V Output → Fuse Block → Left/Right Switches → LED Lights
                                     (Wall mounted)     (3W each)
```

### Entry Light Circuit  
```
EcoFlow 12V Output → Fuse Block → Exterior Lights with Integral Switches
                                     (5W each, weatherproof)
```

### USB Charging Circuit
```
EcoFlow 12V Output → Fuse Block → USB Hub/Converter → Individual USB Ports
                                     (12V to 5V)        (2.4A each)
```

### MaxxFan Circuit
```
EcoFlow 12V Output → Fuse Block → MaxxFan Controller → Fan Motor
                                     (Variable speed)    (0-3A)
```

## Installation Details

### EcoFlow Cabinet Wiring
- **Internal Access Panel**: Hinged door for EcoFlow access
- **Cable Management**: Strain reliefs for all connections
- **Ventilation**: Gaps around unit for heat dissipation
- **Security**: Retention system to prevent movement during travel

### Exterior Input Panel
- **Weatherproof Enclosure**: NEMA 4X rating
- **Pass-through Fittings**: Sealed cable entries
- **Mounting**: Secure attachment to camper body
- **Access**: Labeled for shore power and solar inputs

### Interior Switch Placement
| Switch Location | Height | Function | Type |
|-----------------|--------|----------|------|
| Left Headboard | 40" | Left Reading Light | Toggle |
| Right Headboard | 40" | Right Reading Light | Toggle |
| Near EcoFlow | 38" | MaxxFan Control | Variable |

### USB Port Installation
- **Mounting**: Flush-mount in cabinet faces
- **Protection**: Individual port covers
- **Wiring**: Home-run to distribution point
- **Labeling**: Clear identification of each port

## Safety & Protection

### Overcurrent Protection
- **Main Feed**: 15A fuse at EcoFlow output
- **Branch Circuits**: Individual fuses per circuit
- **EcoFlow Protection**: Built-in BMS and protection

### Ground Fault Protection
- **DC System**: Not required for 12V system
- **AC Shore Power**: EcoFlow has built-in GFCI
- **Grounding**: System negative to chassis ground

### Installation Safety
- **Wire Routing**: Protected from abrasion and heat
- **Connections**: All connections properly terminated
- **Access**: Service access to all components
- **Documentation**: Circuit labels and documentation

## Power Management

### Battery Monitoring
- **EcoFlow Display**: Built-in battery level indicator
- **No Additional Monitoring**: EcoFlow handles all battery management
- **Low Voltage**: EcoFlow automatically shuts down at low battery

### Charging Management
- **Shore Power**: EcoFlow handles charging automatically
- **Solar Input**: EcoFlow MPPT controller manages solar
- **Combined Charging**: Can charge from both sources simultaneously

### Load Management
- **Priority Loads**: Essential lighting and ventilation
- **Optional Loads**: USB charging can be disconnected if needed
- **User Control**: Manual switching for all circuits

## Maintenance & Service

### Regular Maintenance
- **Visual Inspection**: Check all connections monthly
- **Fuse Check**: Verify all fuses annually
- **Cleaning**: Keep EcoFlow ventilation clear

### Service Access
- **EcoFlow Removal**: Can be easily removed for service
- **Fuse Block**: Accessible in headboard storage
- **External Connections**: Service access from exterior panel

### Troubleshooting
- **Circuit Testing**: Individual circuit isolation possible
- **Component Testing**: All components individually testable
- **Documentation**: Complete wiring diagrams maintained

## Future Expansion Options

### Additional Circuits
- **Interior Outlets**: 12V accessory outlets can be added
- **External Outlets**: Exterior 12V for accessories
- **Additional Lighting**: Work lights or accent lighting

### Power Upgrades
- **Larger EcoFlow**: Can upgrade to higher capacity unit
- **Additional Solar**: More solar panels can be connected
- **Shore Power Upgrade**: 30A service possible with different EcoFlow

### Monitoring Upgrades  
- **Remote Monitoring**: Bluetooth/WiFi monitoring possible
- **Usage Tracking**: Add power monitoring if desired
- **Integration**: Smart home integration possible