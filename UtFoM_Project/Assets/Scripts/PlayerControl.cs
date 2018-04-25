using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayerControl : MonoBehaviour
{
    public bool isGrounded = true;
    public int currentAtk, currentHealth, currentSpd, extraAtk, extraSpd, extraHealth,
       maxHealth, weaponAtk;
    public float deadzone, hSpeed, moveSpeed, runSpeed, stickAngle, stickDir, stickX, stickY,
        vSpeed, walkSpeed;
    private string hori = "Horizontal", vert = "Vertical", respawnName;
    public Animator animator;
    public Rigidbody2D body;
    private ArrayList inv;

    void movePlayer()
    {
        if (/*(Input.GetAxis("RT") > 0) || */(Input.GetKey("r")))
        {
            moveSpeed = runSpeed;
        }
        else
        {
            moveSpeed = walkSpeed;
        }

        // Calculates correct direction and magnitude for obj_player movement speeds
        stickX = Input.GetAxisRaw(hori);
        stickY = Input.GetAxisRaw(vert);
        if (stickX == 0 && stickY == 0)
        {
            stickDir = 0;
        }
        else
        {
            stickDir = (float)System.Math.Atan(Input.GetAxisRaw(vert) / Input.GetAxisRaw(hori));
        }
        hSpeed = (float)System.Math.Cos(stickDir) * moveSpeed * System.Math.Sign(Input.GetAxisRaw(hori));
        vSpeed = (float)System.Math.Sin(stickDir) * moveSpeed;
        
        if (Input.GetAxisRaw(hori) < 0 && Input.GetAxisRaw(vert) < 0)
        {
            vSpeed *= System.Math.Sign(Input.GetAxisRaw(vert));
        }
        else if (Input.GetAxisRaw(hori) < 0 && Input.GetAxisRaw(vert) > 0)
        {
            vSpeed *= -1;
        }

        // Applies movement changes
        if (System.Math.Abs(Input.GetAxisRaw(hori)) >= deadzone || System.Math.Abs(Input.GetAxisRaw(vert)) >= deadzone)
        {
            //transform.Translate(new Vector2(hSpeed, vSpeed));
            body.velocity = new Vector2(hSpeed, vSpeed);
        }
        else
        {
            //body.velocity = new Vector2(0f, 0f);
            body.velocity = Vector2.zero;
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
        animator.SetBool("isGrounded", isGrounded);
        animator.SetFloat("stickAngle", stickAngle);
    }

	// Use this for initialization
	void Start() 
	{
        walkSpeed = currentSpd;
        runSpeed = currentSpd * 1.5f;

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
