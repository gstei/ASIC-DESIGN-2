# Bericht 2

## 1. Tapeout
### Select Hardware Blocks?
- OTA

### Problems
- Copper density restrictions -> copper on transistors
- Shielding of measurement signals


## 2. Test-Setup
### Goal
- Line step
- Load step
- Regulation accuracy
- Efficiency
- Startup behavior
- SPI digital interface

### Hardware
- Allow for same test-cases as simulation
-> Voltage and Current measurements
-> SPI testing
-> Characteristics of Temperature

#### Overview
- Main Adapter PCB with common circuits
- TPS hat for test-setup bring-up
- Socketed ASIC hat for characterization of many devices
- Chipdown ASIC hat quicker temperature tests and possibly more realistic as no Socket involved

#### Adapter PCB
Quick PCB rundown

#### Hat PCBs
Quick PCB rundown and and ideas for testing (A/D buffers)

### Software
#### General Architecture
Python Script, saving data in DB, images, running on NI PIX
#### Measurement Instruments
Brief introduction of SMU, PSU, Scope, Thermal chamber

## 3. Chip Testing
### Goal
