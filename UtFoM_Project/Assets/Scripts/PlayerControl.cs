using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayerControl : MonoBehaviour 
{
    private string hori = "Horizontal", vert = "Vertical", respawnName;
    public int currentAtk, currentHealth, currentSpd, extraAtk, extraSpd, extraHealth,
        maxHealth, weaponAtk;
    public float deadzone, hSpeed, moveSpeed, runSpeed, stickAngle, stickDir, stickX, stickY, 
        vSpeed, walkSpeed;
    private ArrayList inv;
    private Animator animator;
    private Rigidbody2D body;

    void movePlayer()
    {
        if ((Input.GetAxis("RT") > 0) || (Input.GetKey("r")))
        {
            moveSpeed = runSpeed;
        }
        else
        {
            moveSpeed = walkSpeed;
        }
    }

    void determineAngle()
    {
        if (System.Math.Abs(Input.GetAxisRaw(hori)) >= deadzone || System.Math.Abs(Input.GetAxisRaw(vert)) >= deadzone)
        {
            if (System.Math.Sign(Input.GetAxisRaw(hori)) > 0 && System.Math.Sign(Input.GetAxisRaw(vert)) > 0)
            {
                stickAngle = stickDir * 180 / (float)System.Math.PI;
            }
            else if (System.Math.Sign(Input.GetAxisRaw(hori)) < 0 && System.Math.Sign(Input.GetAxisRaw(vert)) > 0)
            {
                stickAngle = (stickDir * 180 / (float)System.Math.PI) + 180;
            }
            else if (System.Math.Sign(Input.GetAxisRaw(hori)) < 0 && System.Math.Sign(Input.GetAxisRaw(vert)) < 0)
            {
                stickAngle = (stickDir * 180 / (float)System.Math.PI) + 180;
            }
            else if (System.Math.Sign(Input.GetAxisRaw(hori)) > 0 && System.Math.Sign(Input.GetAxisRaw(vert)) < 0)
            {
                stickAngle = (stickDir * 180 / (float)System.Math.PI) + 360;
            }
            else if (Input.GetAxisRaw(hori) == 0 && System.Math.Sign(Input.GetAxisRaw(vert)) == 1)
            {
                stickAngle = 90;
            }
            else if (System.Math.Sign(Input.GetAxisRaw(hori)) == -1 && Input.GetAxisRaw(vert) == 0)
            {
                stickAngle = 180;
            }
            else if (Input.GetAxisRaw(hori) == 0 && System.Math.Sign(Input.GetAxisRaw(vert)) == -1)
            {
                stickAngle = 270;
            }
            else
            {
                stickAngle = stickDir * 180 / (float) System.Math.PI;
            }
        }
    }

    void animatePlayer()
    {
        determineAngle();
        animator.SetFloat("Stick's Angle", stickAngle);
    }

	// Use this for initialization
	void Start() 
	{
        animator = GetComponent<Animator>();
        body = GetComponent<Rigidbody2D>();
	}
	
	// Update is called once per frame
	void Update() 
	{
        movePlayer();
        animatePlayer();
	}
}
