#include <AsyncDelay.h>
#include <SoftWire.h>

#include <max86150.h>
#include <Wire.h>
#include "max86150.h"

MAX86150 max86150Sensor;

#define debug Serial //Uncomment this line if you're using an Uno or ESP
//#define debug SerialUSB //Uncomment this line if you're using a SAMD21

uint16_t ppgunsigned16;

void setup()
{
    debug.begin(9600);
    debug.println("MAX86150 PPG Streaming Example");

    // Initialize sensor
    if (max86150Sensor.begin(Wire, I2C_SPEED_FAST) == false)
    {
        debug.println("MAX86150 was not found. Please check wiring/power. ");
        while (1);
    }

    debug.println(max86150Sensor.readPartID());

    max86150Sensor.setup(); //Configure sensor. Use 6.4mA for LED drive
}

void loop()
{
    if(max86150Sensor.check()>0)
    {
        ppgunsigned16 = (uint16_t) (max86150Sensor.getFIFORed()>>2);
        debug.println(ppgunsigned16);
    }
}
