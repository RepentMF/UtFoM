using System.Collections;
using System.Collections.Generic;
using UnityEngine.UI;
using UnityEngine;

public class scr_uiControl : MonoBehaviour 
{
    public Slider health;
    public Text healthText;
    public Text lvlText;
    public scr_playerHealthControl playerHealthControl;
    private static bool uiExists;
    private scr_playerStatControl playerStatControl;

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

        playerStatControl = GetComponent<scr_playerStatControl>();
    }

    // Update is called once per frame
    void Update () 
	{
        health.maxValue = playerHealthControl.maxHP;
        health.value = playerHealthControl.currentHP;
        healthText.text = "HP: " + playerHealthControl.currentHP + " / " + playerHealthControl.maxHP;

        lvlText.text = "Level " + playerStatControl.currentLvl;
    }
}
