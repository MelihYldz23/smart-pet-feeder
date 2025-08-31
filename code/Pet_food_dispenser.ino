#include <WiFi.h>
#include <WebServer.h>
#include <ESP32Servo.h>

const char* ssid = "Melih iPhone’u";
const char* password = "melih2324";

WebServer server(80);
Servo myServo;

int servoPin = 15;
int buzzerPin = 23;

int currentAngle = 0;
int portionAngle = 30;  // Her adımda döneceği derece
int duration = 1000;

void beepBuzzer(int timeMs = 1000) {
  digitalWrite(buzzerPin, HIGH);
  delay(timeMs);
  digitalWrite(buzzerPin, LOW);
}

void handleFeedNow() {
  Serial.println("Mama verme isteği alındı");

  
  if (currentAngle >= 180) {
    Serial.println("180 dereceye ulaşıldı, başa dönülüyor.");
    myServo.attach(servoPin);
    myServo.write(0);
    delay(500);
    myServo.detach();
    currentAngle = 0;
  }

  
  int nextAngle = currentAngle + portionAngle;
  if (nextAngle > 180) {
    nextAngle = 180;
  }

  myServo.attach(servoPin);
  myServo.write(nextAngle);
  beepBuzzer(500);
  delay(500);
  myServo.detach();

  currentAngle = nextAngle;

  server.send(200, "text/plain", "Mama verildi. Şu anki açı: " + String(currentAngle));
}

void handleSetPortion() {
  if (server.hasArg("angle")) {
    int angle = server.arg("angle").toInt();
    if (angle >= 10 && angle <= 180) {
      portionAngle = angle;
      Serial.printf("Porsiyon açısı %d derece olarak ayarlandı\n", portionAngle);
      server.send(200, "text/plain", "Porsiyon açısı ayarlandı: " + String(portionAngle));
    } else {
      server.send(400, "text/plain", "Açı 10 ile 180 arasında olmalı");
    }
  } else {
    server.send(400, "text/plain", "Eksik parametre: angle");
  }
}

void handleStatus() {
  server.send(200, "application/json", "{\"status\": \"Çalışıyor\"}");
}

void setup() {
  Serial.begin(115200);

  pinMode(buzzerPin, OUTPUT);
  digitalWrite(buzzerPin, LOW);

  
  myServo.attach(servoPin);
  myServo.write(0);
  delay(500);
  myServo.detach();
  currentAngle = 0;

  WiFi.begin(ssid, password);
  Serial.print("WiFi'ye bağlanılıyor...");
  while (WiFi.status() != WL_CONNECTED) {
    delay(1000);
    Serial.print(".");
  }
  Serial.println(" Bağlandı!");
  Serial.println(WiFi.localIP());

  server.on("/feed", handleFeedNow);
  server.on("/status", handleStatus);
  server.on("/set_portion", handleSetPortion);

  server.begin();
  Serial.println("Sunucu başlatıldı.");
}

void loop() {
  server.handleClient();
}
