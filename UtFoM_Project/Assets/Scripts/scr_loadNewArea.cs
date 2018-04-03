using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class scr_loadNewArea : MonoBehaviour
{
    public string newAreaName;

    private void OnTriggerEnter2D(Collider2D collision)
    {
        if (collision.gameObject.name == "obj_player")
        {
            Application.LoadLevel(newAreaName);
        }
    }

    // Use this for initialization
    void Start()
    {
		
	}
	
	// Update is called once per frame
	void Update()
    {
		
	}
}
