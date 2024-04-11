import pyftdi.spi as spi

# Instantiate a SPI controller
spi = spi.SpiController()

# Configure the first interface (IF/1) of the first FTDI device as a
# SPI master
spi.configure('ftdi://::/1')

# Get a SPI port to a SPI slave w/ /CS on A*BUS3 and SPI mode 0 @ 100kHz
slave = spi.get_port(cs=0, freq=100e3, mode=0)

# Get GPIO port to manage extra pins, use A*BUS4 as GPO, A*BUS4 as GPI
gpio = spi.get_gpio()
gpio.set_direction(0x30, 0x10)

# Assert GPO pin
gpio.write(0x10)
# Write to SPI slace
slave.write(b'hello world!')
# Release GPO pin
gpio.write(0x00)
# Test GPIO pin
pin = bool(gpio.read() & 0x20)
