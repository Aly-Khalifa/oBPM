/***************************************************
  Arduino library written for the Maxim MAX86150 ECG and PPG integrated sensor

	Written by Ashwin Whitchurch, ProtoCentral Electronics (www.protocentral.com)

	https://github.com/protocentral/protocentral_max86150

  Based on code written by Peter Jansen and Nathan Seidle (SparkFun) for the MAX30105 sensor
  BSD license, all text above must be included in any redistribution.
 *****************************************************/

#pragma once

#define MAX86150_ADDRESS          0x5E //7-bit I2C Address

#define I2C_BUFFER_LENGTH 64

#include <stdint.h>
#include <stdbool.h>

typedef uint8_t byte;

bool max86150_begin(void);

uint32_t max86150_getRed(void); //Returns immediate red value
uint32_t max86150_getIR(void); //Returns immediate IR value
int32_t max86150_getECG(void); //Returns immediate ECG value
bool max86150_safeCheck(uint8_t maxTimeToCheck); //Given a max amount of time, check for new data

// Configuration
void max86150_softReset();
void max86150_shutDown();
void max86150_wakeUp();

void max86150_setLEDMode(uint8_t mode);

void max86150_setADCRange(uint8_t adcRange);
void max86150_setSampleRate(uint8_t sampleRate);
void max86150_setPulseWidth(uint8_t pulseWidth);

void max86150_setPulseAmplitudeRed(uint8_t value);
void max86150_setPulseAmplitudeIR(uint8_t value);
void max86150_setPulseAmplitudeProximity(uint8_t value);

void max86150_setProximityThreshold(uint8_t threshMSB);

//Multi-led configuration mode (page 22)
void max86150_enableSlot(uint8_t slotNumber, uint8_t device); //Given slot number, assign a device to slot
void max86150_disableSlots(void);

// Data Collection

//Interrupts (page 13, 14)
uint8_t max86150_getINT1(void); //Returns the main interrupt group
uint8_t max86150_getINT2(void); //Returns the temp ready interrupt
void max86150_enableAFULL(void); //Enable/disable individual interrupts
void max86150_disableAFULL(void);
void max86150_enableDATARDY(void);
void max86150_disableDATARDY(void);
void max86150_enableALCOVF(void);
void max86150_disableALCOVF(void);
void max86150_enablePROXINT(void);
void max86150_disablePROXINT(void);
void max86150_enableDIETEMPRDY(void);
void max86150_disableDIETEMPRDY(void);

//FIFO Configuration (page 18)
void max86150_setFIFOAverage(uint8_t samples);
void max86150_enableFIFORollover();
void max86150_disableFIFORollover();
void max86150_setFIFOAlmostFull(uint8_t samples);

//FIFO Reading
uint16_t max86150_check(void); //Checks for new data and fills FIFO
uint8_t max86150_available(void); //Tells caller how many new samples are available (head - tail)
void max86150_nextSample(void); //Advances the tail of the sense array
uint32_t max86150_getFIFORed(void); //Returns the FIFO sample pointed to by tail
uint32_t max86150_getFIFOIR(void); //Returns the FIFO sample pointed to by tail
int32_t max86150_getFIFOECG(void); //Returns the FIFO sample pointed to by tail

uint8_t max86150_getWritePointer(void);
uint8_t max86150_getReadPointer(void);
void max86150_clearFIFO(void); //Sets the read/write pointers to zero

//Proximity Mode Interrupt Threshold
void max86150_setPROXINTTHRESH(uint8_t val);

// Die Temperature
float max86150_readTemperature();
float max86150_readTemperatureF();

// Detecting ID/Revision
uint8_t max86150_getRevisionID();
uint8_t max86150_readPartID();
uint8_t max86150_readRegLED();

// Setup the IC with user selectable settings
//void max86150_setup(byte powerLevel = 0x1F, byte sampleAverage = 4, byte ledMode = 3, int sampleRate = 400, int pulseWidth = 411, int adcRange = 4096);
void max86150_setup(byte powerLevel, byte sampleAverage, byte ledMode, int sampleRate, int pulseWidth, int adcRange);

// Low-level I2C communication
uint8_t max86150_readRegister8(uint8_t address, uint8_t reg);
void max86150_writeRegister8(uint8_t address, uint8_t reg, uint8_t value);
