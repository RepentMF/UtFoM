using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class scr_playerHealthControl : MonoBehaviour
{
    public int maxHP;
    public int currentHP;

    public void damagePlayer(int damage)
    {
        currentHP -= damage;
    }

    public void resetCurrentHP()
    {
        currentHP = maxHP;
    }

	// Use this for initialization
	void Start()
    {
        resetCurrentHP();
	}
	
	// Update is called once per frame
	void Update()
    {
		if (currentHP <= 0)
        {
            gameObject.SetActive(false);
        }
	}
}
