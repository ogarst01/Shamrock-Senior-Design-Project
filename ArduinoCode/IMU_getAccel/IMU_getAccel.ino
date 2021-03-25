#include <Adafruit_FXOS8700.h>
#include <Adafruit_Sensor.h>
#include <Wire.h>

/* Assign a unique ID to this sensor at the same time */
Adafruit_FXOS8700 accelmag = Adafruit_FXOS8700(0x8700A, 0x8700B);
// declare global variables: 
int prev_vel_x;
int prev_vel_y;
int prev_vel_z;
int x_f;
int y_f;
int z_f;
int x_0;
int y_0;
int z_0;
int accelX;
int accelY;
int accelZ;
int curr_vel_x;
int curr_vel_y;
int curr_vel_z; 

int dt = 500;

void displaySensorDetails(void) {
  sensor_t accel, mag;
  accelmag.getSensor(&accel, &mag);
  Serial.println("ACCELEROMETER");

  /*Serial.println("------------------------------------");
  Serial.println("ACCELEROMETER");
  Serial.println("------------------------------------");
  Serial.print("Sensor:       ");
  Serial.println(accel.name);
  Serial.print("Driver Ver:   ");
  Serial.println(accel.version);
  Serial.print("Unique ID:    0x");
  Serial.println(accel.sensor_id, HEX);
  Serial.print("Min Delay:    ");
  Serial.print(accel.min_delay);
  Serial.println(" s");
  Serial.print("Max Value:    ");
  Serial.print(accel.max_value, 4);
  Serial.println(" m/s^2");
  Serial.print("Min Value:    ");
  Serial.print(accel.min_value, 4);
  Serial.println(" m/s^2");
  Serial.print("Resolution:   ");
  Serial.print(accel.resolution, 8);
  Serial.println(" m/s^2");
  Serial.println("------------------------------------");
  Serial.println("");
  Serial.println("------------------------------------");
  Serial.println("MAGNETOMETER");
  Serial.println("------------------------------------");
  Serial.print("Sensor:       ");
  Serial.println(mag.name);
  Serial.print("Driver Ver:   ");
  Serial.println(mag.version);
  Serial.print("Unique ID:    0x");
  Serial.println(mag.sensor_id, HEX);
  Serial.print("Min Delay:    ");
  Serial.print(accel.min_delay);
  Serial.println(" s");
  Serial.print("Max Value:    ");
  Serial.print(mag.max_value);
  Serial.println(" uT");
  Serial.print("Min Value:    ");
  Serial.print(mag.min_value);
  Serial.println(" uT");
  Serial.print("Resolution:   ");
  Serial.print(mag.resolution);
  Serial.println(" uT");
  Serial.println("------------------------------------");
  Serial.println("");
  */
  delay(500);
}

void setup(void) {
  Serial.begin(9600);

  /* Wait for the Serial Monitor */
  while (!Serial) {
    delay(1);
  }

  Serial.println("FXOS8700 Test");
  Serial.println("");

  /* Initialise the sensor */
  if (!accelmag.begin(ACCEL_RANGE_4G)) {
    /* There was a problem detecting the FXOS8700 ... check your connections */
    Serial.println("Ooops, no FXOS8700 detected ... Check your wiring!");
    while (1)
      ;
  }

  /* Display some basic information on this sensor */
  displaySensorDetails();

  // start at origin from rest
  x_0 = 0;
  y_0 = 0;
  z_0 = 0;

  prev_vel_x = 0;
  prev_vel_y = 0;
  prev_vel_z = 0;
}

void loop(void) {
  
  sensors_event_t aevent, mevent;

  /* Get a new sensor event */
  accelmag.getEvent(&aevent, &mevent);

  /* Display the accel results (acceleration is measured in m/s^2) */
  Serial.print("A ");
  Serial.print("X: ");
  Serial.print(aevent.acceleration.x, 4);
  Serial.print("  ");
  Serial.print("Y: ");
  Serial.print(aevent.acceleration.y, 4);
  Serial.print("  ");
  Serial.print("Z: ");
  Serial.print(aevent.acceleration.z, 4);
  Serial.print("  ");
  Serial.println("m/s^2");
  
  /* We know from Physics 101:
    x_f = x_0 + v_0 * dt + 0.5*a*t^2
    v_f = v_0 + a*dt
  */

  /* Update and print the curent position in x, y, z: */
  dt = 0.5; // hard coded into the update:
  accelX = aevent.acceleration.x;
  accelY = aevent.acceleration.y;
  accelZ = aevent.acceleration.z;

  // calculate current velocity: 
  curr_vel_x = prev_vel_x + accelX*dt;
  curr_vel_y = prev_vel_y + accelY*dt;
  curr_vel_z = prev_vel_z + accelZ*dt;

  // calculate position:
  x_f = x_0 + curr_vel_x*dt + (0.5*accelX*(dt^2));
  y_f = y_0 + curr_vel_y*dt + (0.5*accelY*(dt^2));
  z_f = z_0 + curr_vel_z*dt + (0.5*accelZ*(dt^2));

  Serial.println("x_f \n");
  Serial.println("y_f \n");
  Serial.println("z_f \n");

  // update the values here:
  prev_vel_x = curr_vel_x;
  prev_vel_y = curr_vel_y;
  prev_vel_z = curr_vel_z;

  x_0 = z_f;
  y_0 = y_f;
  z_0 = z_f;

  delay(500);
}



  /* Display the mag results (mag data is in uTesla) 
  Serial.print("M ");
  Serial.print("X: ");
  Serial.print(mevent.magnetic.x, 1);
  Serial.print("  ");
  Serial.print("Y: ");
  Serial.print(mevent.magnetic.y, 1);
  Serial.print("  ");
  Serial.print("Z: ");
  Serial.print(mevent.magnetic.z, 1);
  Serial.print("  ");
  Serial.println("uT");

  Serial.println("");
  */
