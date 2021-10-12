#include <SPI.h>
#include <Ethernet.h>

//LED variables
int led1=4;
int led2=6;
//String resultBefore="0";
//String result2Before="0";

//============================================
String readString, readStringTheCommand;

byte mac[] = { 0x90, 0xA2, 0xDA, 0x00, 0x11, 0xAC };
byte ip[] = { 192, 168, 1, 19 };

//IP-SERVER
byte server[] = { 192,168,1,20 };

EthernetClient client; //(server, 80);

//======================
//the command
String str;
  int i=0;
//======================================SETUP()
void setup()
{
    Serial.begin(9600);
    Serial.println("setting ,ac and ip address.....");
    //Ethernet.begin(mac, ip);
    Ethernet.begin(mac, ip);  //set ethernet ip

    Serial.println("starting simple arduino client test....");
    //Serial.println(ind);
    Serial.println("connecting...");
    pinMode(led1, OUTPUT);
    pinMode(led2, OUTPUT);
}   //end of setup

void loop() {
  //status Led1 and led2 variable
  String result, result2;
  
  //GET kode from kode_tb
  Serial.println("Connecting to server Database ");
  if (client.connect(server, 80))
  { 
    //=========================
    //Get kode_tb for led1 and led2
    client.print("GET /iot2020/get_database_iot2020.php?");
    Serial.print("GET /iot2020/get_database_iot2020.php?");
    client.println(" HTTP/1.1");
    Serial.println(" HTTP/1.1");
    client.println("Host: localhost");
//    Serial.println("Host: localhost");
    client.println("User-Agent: arduino-ethernet");
//    Serial.println("User-Agent: arduino-ethernet");
    client.println("Accept: text/html");
//    Serial.println("Accept: text/html");
    client.println("Connection: close");
//    Serial.println("Connection: close");
    client.println();
    client.println();

    Serial.println("\nCOMPLETE!\n");
  
    // Read response from server
    i=0;
    while (client.available())
    {
      result = client.readStringUntil('\r');
      result2 = result;
    }
    result = result.substring(13,14);
    result2 = result2.substring(44,45);
    Serial.println(result);
    Serial.println(result2);

    delay(50);
    client.stop(); // disconnect
    client.flush();
  }


  //input data led1
   Serial.println("Connecting to server Database ");
  if (client.connect(server, 80))
  { 
    if(result=="1" && (result2=="0" || result2=="1")){
      digitalWrite(led1, HIGH);
      client.print("GET /iot2020/insert_iot2020.php?led1=1");
      Serial.print("GET /iot2020/insert_iot2020.php?led1=1");
      client.println(" HTTP/1.1");
      Serial.println(" HTTP/1.1");
      client.println("Host: localhost");
  //    Serial.println("Host: localhost");
      client.println("User-Agent: arduino-ethernet");
  //    Serial.println("User-Agent: arduino-ethernet");
      client.println("Accept: text/html");
  //    Serial.println("Accept: text/html");
      client.println("Connection: close");
  //    Serial.println("Connection: close");
      client.println();
      client.println();
    }
    else if(result=="0"){
      digitalWrite(led1,LOW);
      client.print("GET /iot2020/insert_iot2020.php?led1=0");
      Serial.print("GET /iot2020/insert_iot2020.php?led1=0");
      client.println(" HTTP/1.0");
      Serial.println(" HTTP/1.0");
      client.println("Host: localhost");
  //    Serial.println("Host: localhost");
      client.println("User-Agent: arduino-ethernet");
  //    Serial.println("User-Agent: arduino-ethernet");
      client.println("Accept: text/html");
  //    Serial.println("Accept: text/html");
      client.println("Connection: close");
  //    Serial.println("Connection: close");
      client.println();
      client.println();
    }
//    
    delay(50);
    client.stop(); // disconnect
    client.flush();
  }


    //input data led2
    Serial.println("Connecting to server Database ");
  if (client.connect(server, 80))
  { 
    if(result2=="1"){
      digitalWrite(led2, HIGH);
       client.print("GET /iot2020/insert_iot2020.php?led2=1");
      Serial.print("GET /iot2020/insert_iot2020.php?led2=1");
      client.println(" HTTP/1.0");
      Serial.println(" HTTP/1.0");
      client.println("Host: localhost");
  //    Serial.println("Host: localhost");
      client.println("User-Agent: arduino-ethernet");
  //    Serial.println("User-Agent: arduino-ethernet");
      client.println("Accept: text/html");
  //    Serial.println("Accept: text/html");
      client.println("Connection: close");
  //    Serial.println("Connection: close");
      client.println();
      client.println();
    }
    else if(result2=="0"){
      digitalWrite(led2,LOW);
      client.print("GET /iot2020/insert_iot2020.php?led2=0");
      Serial.print("GET /iot2020/insert_iot2020.php?led2=0");
      client.println(" HTTP/1.0");
      Serial.println(" HTTP/1.0");
      client.println("Host: localhost");
  //    Serial.println("Host: localhost");
      client.println("User-Agent: arduino-ethernet");
  //    Serial.println("User-Agent: arduino-ethernet");
      client.println("Accept: text/html");
  //    Serial.println("Accept: text/html");
      client.println("Connection: close");
  //    Serial.println("Connection: close");
      client.println();
      client.println();
    }

    delay(50);
    client.stop(); // disconnect
    client.flush();
  }
}
