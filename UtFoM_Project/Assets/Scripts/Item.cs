using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Item : MonoBehaviour
{
    public int atkUp, healthRestore, healthUp, keyID, quantity, spdUp, 
        stmRestore, stmUp, torch;
    public int[] returnVal;
    public string type;

    public int[] Use
    {
        get
        {
            switch (type)
            {
                case "attack":
                    returnVal[0] = atkUp;
                    break;
                case "estus":
                    returnVal[0] = healthRestore;
                    returnVal[1] = stmRestore;
                    break;
                case "health":
                    returnVal[0] = healthUp;
                    break;
                case "speed":
                    returnVal[0] = spdUp;
                    break;
                case "stamina":
                    returnVal[0] = stmUp;
                    break;
                case "key":
                    returnVal[0] = keyID;
                    break;
                case "torch":
                    returnVal[0] = torch;
                    break;
            }

            return returnVal;
        }
    }

	// Use this for initialization
	void Start() 
	{
        returnVal = new int[3];
	}
	
	// Update is called once per frame
	void Update() 
	{
		
	}
}
