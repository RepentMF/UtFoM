using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class scr_damagePlayer : MonoBehaviour 
{
    public int damage;

    void OnCollisionEnter2D(Collision2D collision)
    {
        if (collision.gameObject.name == "obj_player")
        {
            collision.gameObject.GetComponent<scr_playerHealthControl>().damagePlayer(damage);
        }
    }

    // Use this for initialization
    void Start () 
	{
		
	}
	
	// Update is called once per frame
	void Update () 
	{
		
	}
}
