using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class scr_enemyHealthControl : MonoBehaviour 
{
    public int maxHP;
    private int currentHP;

    public void damageEnemy(int damage)
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
            Destroy(gameObject);
        }
    }
}
