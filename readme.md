DAD wafersaw sequence creation tool for fluidic channel cutting
===============================================================

This tool accompanies the works of my term paper, written in 2014 entitled: "Determination of the Influence of Nozzle Dimension as well as Electrical Control of a Microdroplet Generator on the Droplet Formation Process". The context of the thesis is a piezo-electrically driven micro-droplet generator.
The semester thesis is written in German language and can be found in the root of this repository (github.com/ameeuw/DAD320_Wafersaw_Channel_Creator/2014_05_ST_Arne_Meeuw.pdf). 
The following German description is for the software only:

**Bearbeitetes Konzept:**

Ziel ist die automatische Erstellung von Wafers�genprogrammen zur Herstellung individueller D�sen. Hierzu werden die gew�nschten D�sendimensionen (Breite, L�nge und Tiefe) und das verwendete S�geblatt (Breite) in einer graphischen Benutzeroberfl�che der erstellten Software eingetragen. Die Software erstellt automatisch die Programme, welche �ber eine 3,5� Diskette in die Wafers�ge DAD321 von DISCO importiert werden.

**Realisierung:**

Unter Verwendung der Programmierumgebung MATLAB entstand ein Programm welches nach Eingabe der ben�tigten Kanal- und Materialparameter, das korrekte Schnittprogramm erstellt. Die wichtigsten Parameter stellen hierbei die Kanalbreite b [�m] und S�geblattbreite d [�m] dar. Die Orientierungsgr��e f�r die Versatzbreite s [�m] wird standardm��ig auf ein Viertel der S�geblattbreite d gesetzt, kann aber durch �nderung im entsprechenden Feld frei gew�hlt werden. Mit den Parametern wird nun die ben�tigte Anzahl an Schnitten n errechnet und mit dieser nun wiederrum der ben�tigte tats�chliche Versatz s. Nach Eingabe der zus�tzlichen Wafers�genparameter Umdrehungsgeschwindigkeit der Spindel [Umdrehungen pro Minute], L�nge des Schnittes [mm], Absenkgeschwindigkeit der z-Achse [�m/s], Vorschubgeschwindigkeit des S�geblattes [mm/s] und H�he des Schnittes [�m] wird der Code nach Dr�cken des Knopfes �Create Code� erstellt. Dieser wird in einer Tabellenansicht zur �berpr�fung dargestellt. Diese Ansicht gleicht der Ansicht des Codes in der Wafers�ge, sodass, falls der Import per Diskette nicht m�glich ist, das Programm manuell in die Wafers�ge �bertragen werden kann. Durch einen Druck auf den Knopf �Save DAC� wird eine Textdatei mit der Endung �*.DAC� erstellt, welche die korrekt formatierten Befehle und zugeh�rigen Parameter des zuvor erstellten Programmablaufes beinh�lt. Diese wird am gew�hlten Ort gespeichert und kann von dort aus importiert werden.
Die geschriebene Datei ist nun auf eine 3,5� Diskette zu kopieren. Hierzu steht eine vorgegebene Ordnerstruktur bereit, welche einen Ordner mit dem Namen �DAC� und zwei darin enthaltene Dateien (�ID.LST� und �DEVICE.LST�) zur Verf�gung.

-------------

**From the MATLAB readme:**

MATLAB Compiler

1. Prerequisites for Deployment 

  - Verify the MATLAB Compiler Runtime (MCR) is installed and ensure you    
  have installed version 8.3 (R2014a).   

  - If the MCR is not installed, do the following:
    1 enter
  
      >>mcrinstaller
      
      at MATLAB prompt. The MCRINSTALLER command displays the 
      location of the MCR Installer.

    2 run the MCR Installer.

    Or download the Windows 64-bit version of the MCR for R2014a from the MathWorks Web site by navigating to

    http://www.mathworks.com/products/compiler/mcr/index.html

    NOTE: You will need administrator rights to run MCRInstaller. 


2. Files to Deploy and Package

  - dac_creator.exe

  - MCRInstaller.exe 
     -if end users are unable to download the MCR using the above  
      link, include it when building your component by clicking 
      the "Add MCR" link in the Deployment Tool
  - This readme file 


3. Definitions

  For information on deployment terminology, go to 
  http://www.mathworks.com/help. Select MATLAB Compiler >   
  Getting Started > About Application Deployment > 
  Application Deployment Terms in the MathWorks Documentation 
  Center.