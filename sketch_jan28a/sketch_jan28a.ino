#include <max86150.h>
#include <Wire.h>
#include "max86150.h"

void TCA9548A(uint8_t bus)
{
  Wire.beginTransmission(0x70);  // TCA9548A address is 0x70
  Wire.write(1 << bus);          // send byte to select bus
  Wire.endTransmission();
}


MAX86150 max86150Sensor1;
MAX86150 max86150Sensor2;

#define debug Serial //Uncomment this line if you're using an Uno or ESP
//#define debug SerialUSB //Uncomment this line if you're using a SAMD21

uint16_t Appgunsigned16;

uint16_t Bppgunsigned16;

void setup()
{
    debug.begin(9600);
    debug.println("MAX86150 PPG Streaming Example");
    Wire.begin();
    
    TCA9548A(1);    
    // Initialize sensor
    if (max86150Sensor1.begin(Wire, I2C_SPEED_FAST) == false)
    {
        debug.println("MAX86150 was not found. Please check wiring/power. ");
        while (1);
    }

    debug.println(max86150Sensor1.readPartID());

    max86150Sensor1.setup(); //Configure sensor. Use 6.4mA for LED drive




    TCA9548A(2);    
    // Initialize sensor
    if (max86150Sensor2.begin(Wire, I2C_SPEED_FAST) == false)
    {
        debug.println("MAX86150 was not found. Please check wiring/power. ");
        while (1);
    }

    debug.println(max86150Sensor2.readPartID());

    max86150Sensor2.setup(); //Configure sensor. Use 6.4mA for LED drive

}

void loop()
{
  TCA9548A(1);
  
    if(max86150Sensor1.check()>0)
    {
        Appgunsigned16 = (uint16_t) (max86150Sensor1.getFIFORed()>>2);
        Serial.print(Appgunsigned16);
    }
    

  TCA9548A(2);
  
    if(max86150Sensor2.check()>0)
    {
        Bppgunsigned16 = (uint16_t) (max86150Sensor2.getFIFORed()>>2);
        Serial.print(",");
        Serial.println(Bppgunsigned16);
    }

delay(1);
}
