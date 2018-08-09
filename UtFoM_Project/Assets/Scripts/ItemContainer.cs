using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ItemContainer : MonoBehaviour 
{
    public bool open;
    public int face;
    public Item item;

	// Use this for initialization
	void Start() 
	{
        open = false;
        face = 90;
	}
	
	// Update is called once per frame
	void Update() 
	{
		
	}
}