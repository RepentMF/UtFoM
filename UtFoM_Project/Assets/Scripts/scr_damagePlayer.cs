using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class scr_damagePlayer : MonoBehaviour 
{
    public int damage;
    private int finalDamage;
    private scr_playerStatControl player;

    void OnCollisionEnter2D(Collision2D collision)
    {
        if (collision.gameObject.name == "obj_player")
        {
            finalDamage = damage - player.currentDef;
            if (finalDamage < 0)
            {
                finalDamage = 0;
            }

            collision.gameObject.GetComponent<scr_playerHealthControl>().damagePlayer(finalDamage);
        }
    }

    // Use this for initialization
    void Start () 
	{
        player = FindObjectOfType<scr_playerStatControl>();
	}
	
	// Update is called once per frame
	void Update () 
	{
		
	}
}
