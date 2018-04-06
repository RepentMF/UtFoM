using System.Collections;
using System.Collections.Generic;
using UnityEngine.UI;
using UnityEngine;

public class scr_uiControl : MonoBehaviour 
{
    public Slider health;
    public Text healthText;
    public scr_playerHealthControl playerHealthControl;
    private static bool uiExists;

	// Use this for initialization
	void Start () 
	{
        if (!uiExists)
        {
            uiExists = true;
            DontDestroyOnLoad(transform.gameObject);
        }
        else
        {
            Destroy(gameObject);
        }
    }

    // Update is called once per frame
    void Update () 
	{
        health.maxValue = playerHealthControl.maxHP;
        health.value = playerHealthControl.currentHP;
        healthText.text = "HP: " + playerHealthControl.currentHP + " / " + playerHealthControl.maxHP;
    }
}
