using System;
using System.IO.Ports;

namespace SerialPortExample
{
    class SerialPortProgram
    {
        // Create the serial port with basic settings

        [STAThread]
        static void Main(string[] args)
        {
            // Instatiate this class
            SerialPort port1, port2;
            Console.WriteLine("Enter the port of FPGA1: ");
            string com1 = "";
            do {
                com1 = Console.ReadLine();
                if (!com1.StartsWith("COM"))
                    Console.WriteLine("Invalid input");
            } while (!com1.StartsWith("COM"));
            port1 = new SerialPort(com1, 2000, Parity.None, 8, StopBits.One);
            Console.WriteLine("Enter the port of FPGA2: ");
            string com2 = "";
            do
            {
                com2 = Console.ReadLine();
                if (!com2.StartsWith("COM"))
                    Console.WriteLine("Invalid input");
            } while (!com2.StartsWith("COM"));
            port2 = new SerialPort(com2, 2000, Parity.None, 8, StopBits.One);
            new SerialPortProgram(port1, port2);
        }

        private SerialPortProgram(SerialPort port1, SerialPort port2)
        {
            Console.WriteLine("Incoming Data:");

            // Attach a method to be called when there
            // is data waiting in the port's buffer
            port1.DataReceived += new
              SerialDataReceivedEventHandler(port_DataReceived);
            port2.DataReceived += new
              SerialDataReceivedEventHandler(port_DataReceived);

            // Begin communications
            port1.Open();
            port2.Open();

            string user_response;
            bool x = true;
            int char1, char2;
            while (true)
            {
                Console.WriteLine("Would you like to Transmit and Recieve (y/n):");
                user_response = Console.ReadLine();
                
                if (user_response == "y") 
                {

                    while (x)
                    {
                        Console.WriteLine("Open to TX....");
                        do
                        {
                            char1 = port1.ReadByte();
                        } while (port1.BytesToRead > 0);
                        do
                        {
                            char2 = port2.ReadByte();
                        } while (port2.BytesToRead > 0);
                        //Console.WriteLine(char1.ToString() + "," + char2.ToString());
                        Console.WriteLine("Open to RX....");
                        port2.Write(new char[] { (char)char1 }, 0, 1);
                        port1.Write(new char[] { (char)char2 }, 0, 1);
                        while (port2.BytesToRead > 0)
                            char1 = port1.ReadByte();
                        while (port2.BytesToRead > 0)
                            char2 = port2.ReadByte();
                        Console.WriteLine("Would you like to trasnmit and receive again? (y/n): ");
                        user_response = Console.ReadLine();
                        if (user_response == "y")
                            x = true;
                        else if (user_response == "n")
                        {
                            x = false;
                        }
                        else
                            Console.WriteLine("Invalid Response");
                    }
                }
                else if (user_response == "n")
                {
                    

                }

                else
                    Console.WriteLine("Invalid Response");


                Console.WriteLine("Would you like to continue? (y/n):");
                user_response = Console.ReadLine();
                if (user_response == "y")
                    x = true;
                else if (user_response == "n")
                {
                    Console.WriteLine("Thank you for using TX/RX V1.0");
                    x = false;
                    port1.Close();
                    port2.Close();
                    Environment.Exit(0);
                }
                             

            };
        }

        private void port_DataReceived(object sender,
          SerialDataReceivedEventArgs e)
        {
            SerialPort port = (SerialPort)sender;
            // Show all the incoming data in the port's buffer
            //Console.WriteLine(port.ReadExisting());
            port.ReadExisting();
        }
    }
}
