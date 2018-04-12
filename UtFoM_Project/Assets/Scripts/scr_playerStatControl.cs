using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class scr_playerStatControl : MonoBehaviour 
{
    public int currentLvl;
    public int totalExp;
    public int currentAtk;
    public int currentDef;
    public int[] nextLvlExp;
    public int[] nextLvlHealth;
    public int[] nextLvlAtk;
    public int[] nextLvlDef;
    public scr_playerHealthControl playerHealth;
    
    public void levelUp()
    {
        currentLvl++;
        playerHealth.maxHP = nextLvlHealth[currentLvl];
        playerHealth.currentHP = nextLvlHealth[currentLvl];
        currentAtk = nextLvlAtk[currentLvl];
        currentDef = nextLvlDef[currentLvl];
    }

    public void addExp(int experience)
    {
        totalExp += experience;
    }

	// Use this for initialization
	void Start () 
	{
        playerHealth = FindObjectOfType<scr_playerHealthControl>();
    }
	
	// Update is called once per frame
	void Update () 
	{
        if (totalExp >= nextLvlExp[currentLvl])
        {
            levelUp();
        }
	}
}
