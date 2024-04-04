# Literature Review/ Fundamentals
## SMPS
## Converter Topologies 
Cuk,Sepic, Buck-Boost
## Controller Structure 
Current-Mode Control, Peak vs. Average
## Slope Compensation and sub-harmonic oscillations
Switching Converters based on a fixed frequency Peak-Current-Mode control are susceptible to phenomenon called sub-harmonic oscillations when operating at a duty-cycle greater then 50%. Other control modes are also effected from this phenomenon with varying conditions in which it takes place, in this chapter we will only be evaluating its effects on peak current mode control. Sub-harmonic oscillations is the name given to this phenomenon of oscillations in the inductor current when operating in a steady state as can be seen in figure ???. These oscillations occur in a lower frequency than the switching frequency of the converter and are caused by the inductor current not returning to the start value at the end of the switching cycle. The inductor current should have triangular waveform, oscillating from some minimum value to some maximum value and back in one switching period. As can be seen in figure ??, this is not the case when sub-harmonic oscillations are present. Sub-harmonic oscillations are generally not harmful cite!!, but they can cause audible noise if the oscillations lie in the audible frequency spectrum.
To guarantee  a sub-harmonic oscillation free operation using peak current mode control at high duty-cycles, a technique called slope compensation is employed. Slope compensation reduces the peak current threshold proportional to the pulse width  of the ongoing switching cycle. When correctly implemented, this ensures the inductor current always returns to the value at the start of the switching cycle, eliminating sub-harmonic oscillations in the process. The formulas to calculate the ideal magnitude of slope compensation required are well documented and can be found for most switching converter topologies. 

## Blanking Time with converters
During the switching moment of the MOSFETs and for some time after there is a lot of noise. 

## Current Sensing
Senseresistor, Sensefet, MOSFET RDSon, others
## Synchronous rectification
the diodes in highly integrated and high-power converter designs are often replaced with MOSFETs. This is done to improve efficiency, a practice referred to as synchronous rectification. Diodes in switching converters are used to enable current flow in one direction, but not the other. Diodes are suitable for the this task, but come the drawback of producing a forward voltage drop of around 0.6-0.7V when conducting current. When the currents are sufficiently high or the controller should have a high efficiency, the power dissipation in the diodes becomes non negligible. To reduce the power dissipation of the circuit the diodes can be replaced with MOSFETs, which can act as diodes, if the correct drive signals are applied. By turning on the MOSFETs in the time when the diode would be conducting and turning it off when the diode would block the reverse current flow the function of the diode can be replicated. The power dissipation from this practice is often less than the power dissipation from a diode in the same circumstances. In practice, this drive pattern is simple to implement and can greatly improve the overall efficiency, which explains its the widespread use. All buck-boost converters with integrated switches examined  as part of this project employ synchronous rectification.
Pdis_mosfet = RDS_on * I^2 < Pdis_diode = 0.6V * I

## Modulation Schemes in Switch Mode Power supplies
In switch mode power supplies there are multiple different modulation schemes in use, each with a different advantages and disadvantages. The simplest scheme is pulse width modulation, where the amount of energy transfered from the input to the output is modulated in the width of the pulse. PWM schemes switch in a fixed frequency and change the on time depending on how much power is supposed to be transfered. A simple pulse width modulation can be achieved by comparing to be modulated signal with a sawtooth waveform. Such PWM based control schemes are found in simple converter designs and in more complex converters, when sufficient load is present. These more complex converters often use pulse frequency modulation under light loads. In PFM the pulse width is fixed width and instead the frequency or the time in between pulses is varied. Controller such as the TPS63900 employ completely different modulation schemes.


## Multi Mode Controllers
A common sight in modern Buck-Boost-Converters are controllers with multiple operating modes. This is done to improve efficiency and improve regulation characteristics in different scenarios. A common occurrence is the use of a PWM based operating modes for normal operation and PFM operation for light loads. This is done as it can challenging to measure low currents around 0 A and depending on converter topology could require very short pulse widths. A pulse therefore often easier and more efficient in terms of switching losses to "top up" the output storage element with a small energy pulse when required through a PFM scheme. Another approach is used in converters with very wide operating ranges. They include up to three different modes, one for pure buck conversions, one for buck-boost operating mode for when the input and output voltages are similar and one for pure boost conversions. More common are controller with only a buck converting mode and a buck-boost converting mode as boost operation is seldomly used and the slight efficiency penalty is a worthwhile trade of for the simpler design. A multi mode controller greatly increases design complexity as it not only requires the implementation of multiple different control schemes, but as designer, you also have ensure a smooth transitions between them. In design with narrow operating ranges, the number of operating modes are often reduced to simplify the design. The IC designer as Texas Instruments recognized this problem and found an interesting solution. In ICs like the TPS63900 created their own modulation which is more complected than the modulation schemes presented here, but thise scheme allows them to achieve high efficiency over the whole input and output range. In this way, they do not have to implement multiple operating modes and ensure save transition between them, but were able to created one complex operating for the whole operating range.

## Soft start
When starting the controller 

## Protection
Foldback

# Implementation
In this chapter we will focus on actual implementation of many of the concepts discussed in the previous chapter. The goal is to describe the inner workings of the chip on a conceptual level as well as in a second step the workings of the individual sub blocks. In the first subchapter will explore how the control loop was design from a high level. We will focus on the high-level workings of the controller, some of the problems we encountered and how we over came them. In the second part we will have a detailed look into the underlying subcircuits that make up the chip and will have a detailed look into design decisions at the single transistor level. 
## Controller High-Level
In this subchapter we will give a look in to the design of the control loop on a high level, without getting caught up the CMOS circuits used to create the various subcomponets. We will try to explain the reasons behind our design decisions, why we changed the controller topology late in the design process and how the converter works. All sub circuits can generally be considered ideal in this chapter with occasional references to the ruff underlying implementation considerations where needed.
### Converter Topology
The converter we ended up building is a Cascaded-Buck-Boost converter with Peak-Current-Mode control. We have implemented synchronous rectification and are using the RDS_on of our power MOSFETs to measure the current flowing the inductor.
Based on our literature review of the different converter topologies and an extensive study of similar commercially available ICs we decided to us implement a Cascaded-Buck-Boost converter. This topology is widely used in similar design such as the Texas Instruments TPS63000, which be based a lot of our early design decisions on. We found this IC in particular to be quite similar in the goal it tries to achieve, mainly being a small, highly integrated and high efficiency Buck-Boost-Converter, while still being of a reasonable complexity. More modern controllers use quite complex regulation schemes with multiple operating modes, to eek out the highest possible efficiency. T For our comparatively small operating range and not as high efficiency requirements we decided on using a single PWM based Operating Buck-Boost mode.
### Structure
### Over Current Protection & Short Circuit Protection
### Modeling
### Compensation
## Implementation of CMOS Circuits
Why not from library
### OTAs
Bode Plot, Structure
### Comparator
Rise time, delay, structure 
### Blanking FF
### Current Measurement
Different approaches
### Timing & Slope Compensation

### Power MOSFETS
Drain extension
### Level Shifter

### Nonoverlapping Gate Driver
The function of the gate driver is to convert the low power output signal from the flip flop to a high-current output capable of driving the the power MOSFETs. As the power MOSFETs have a significant size the have a significant gate capacitance which stores a significant gate charge. At every switching cycle the gate charge needs be completely added and removed. As this process takes time, it is important to ensure that both power MOSFETs are not conducting at the same time, as this would cause a large current flowing from the supply through the MOSFETs directly to ground in process called shoot-through. The prevent this we have to ensure the PMOS is competently turned off before turning on the NMOS and vice-versa. To do this we use a non-overlapping driver circuit, which introduces a fixed delay between both drive signals.
We have implemented the circuit from [paper] out of digital cells from XFAB library. In order to  charge the gates we have used a series of inverters with increasing drive strength until in the last stage we are using one inverter with X4 drive strength to drive each gate strand. In addition we have an enable pin to turn off the both power MOSFETs to bring the circuit into a safe state when the circuit is disabled. As it possible that the output voltage is greater than the supply voltage of the chip which we derive from the input pin, we use the aforementioned level shifter to shift the voltage levels from the input voltage to the voltage level at PMOS Source node. Without the level shifter it possible that it would not possible to completely turn off the output PMOS. 

### TSD
In order to protect circuits from sustained overload load conditions a thermal shutdown circuits is often employed. The goal is to measure the silicon temperature near the most heat generating parts of the chip and turn off the heat generating subcircuits if the temperature exceeds a predefined limit. A crude temperature measurement often suffices. TSDs also use hysteresis to prevent the circuit from rapidly shutting down and turning on again. We found the hysteresis of ICs on the market to be around 20°C to 40°C and have a trip point of 140°C to 170°C We based our thermal shutdown circuit on the circuit found in the XFAB ACELLS Library. As this circuit is not suitable for a 5V supply and requires their complementary circuitry to work, we modified it to work in our design. Firstly we changed all MOSFETs to their 5V variants, used or own folded cascode to generate a reference current in the circuit and used the comparator we already designed. In addition we added MOSFET M? to the circuit to increase the current in one strand in the case of an over temperature event to increase the hysteresis of the circuit. Without it the hysteresis is only 7°C and we wanted to increase it to around 30°C to be more in line with the values seen in other designs. 
The circuit works by comparing the forward voltage of two strands of bipolar transistors wired in a diode configuration. The two stands are designed such that both have similar forward voltages at room temperature, but different temperature coefficients. The strands with higher temperature coefficient starts hat a higher voltage at room temperature, but at some higher temperature falls bellow the voltage created by the other strand. This crossover is detected with a comparator, and we will call the temperature at with this crossover happens the crossover temperature. The different temperature coefficients are achieved by using one strand with three series diodes and another with four. By sending a significantly smaller current through the strand with four transistors, the forward voltages are set to level slightly higher then the one in the other strand. As the strand with four transistors has more transistors in series, its forward voltage has larger temperature dependence. By varying the the current through both strands it possible to relatively precisely set the crossover temperature of the circuit. As the voltage of both strands is generated by using the forward voltage of bipolar transistors, both are subjected to the same process variations with can be seen in the vary stable crossover temperature over the process corners. We have set the currents such that we get a crossover temperature of 140°C and a hysteresis of 30°C. 

Table with Values
TI TPS63000, TSD 140°, Hyst 20°C
Renesas ISL9122A, TSD 130°, Hyst 25°C
Maxim MAX8625A, TSD 165°, Hyst 15°C
ST STBB2, TSD 150°, Hyst 20°C
This Design, TSD 140°, Hyst 30°C





# Results
## Specs
