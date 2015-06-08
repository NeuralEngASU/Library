using System;
using System.IO;
using System.Threading;
using System.Text;
using System.Net;
using System.Net.Sockets;

namespace My
{
    public class NetThread
    {
		// Receiving Thread Object
		Thread m_receiveThread;
		
		// UDP Client Object
		UdpClient m_client;
		//	Socket m_client;
		IPEndPoint endPoint;
		
		// IP Address and Port
		private string IP = "127.0.0.1";	// default local
		private int port; 					// define in init
		
		// Containers for the recieved UDP packets
		private string lastUDP = "";
		private string allUDP  = ""; // Make this empty every now and then
		
		// Volatile bool for termination of thread
		public volatile bool terminateFlag;
		
		// String Delimeters
		char[] delimiterChars;
		
		// Global Info
		GlobalInfo m_globalInfo;
		
		// start from unity3d
		void Start(){
			init();
		}
		
		// Initialization of variables
		public void init(){
			// Debug line
			Debug.Log("UDPRecieve.init()");
			
			// define port
			port = 9090;
			
			//		delimiterChars = new char[] {':', ';', '\t', '\n'};
			delimiterChars = new char[] {':', ';'};
			
			// Set termination boolean
			terminateFlag = false;
			
		}// END FUNCTION

		public NetThread(string filename, double[] data)
        {
            this.filename = filename;
            this.doubleData = data;
            thread = new Thread(this.run);
        }
        public void start()
        {
            thread.Start();  // note the capital S in Start()
        }
        private void run()
        {
            try
            {
                BinaryWriter out = new BinaryWriter(
                                   File.Open(filename,FileMode.Create))
                for (int i = 0; i < doubleData.Length; i++)
                {
                    out.Write(doubleData[i]);
                }
                out.Close();
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.Message);
            }
        }
    }
}