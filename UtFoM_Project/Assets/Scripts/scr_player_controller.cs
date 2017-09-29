using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class scr_player_controller : MonoBehaviour
{
    public float stickX, stickY, stickDir, walkSpeed, runSpeed, hSpeed, vSpeed, deadzone;
    public string hori = "Horizontal";
    public string vert = "Vertical";
    private bool groundMovement = false;
    private float moveSpeed, stickAngle;
    private Animator ani;

    // Calculations and checks for player movement speed
    void playerMovement()
    {
        // Checks to see if the player is running
        if (Input.GetAxis("RT") > 0)
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
        stickDir = (float)System.Math.Atan(Input.GetAxisRaw(vert) / Input.GetAxisRaw(hori));
        hSpeed = (float)System.Math.Cos(stickDir) * moveSpeed * System.Math.Sign(Input.GetAxisRaw(hori)) * Time.deltaTime;
        vSpeed = (float)System.Math.Sin(stickDir) * moveSpeed * Time.deltaTime;
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
            transform.Translate(new Vector2(hSpeed, vSpeed));
        }
    }

    void DetStickAngle()
    {
        if (System.Math.Abs(Input.GetAxisRaw(hori)) >= deadzone || System.Math.Abs(Input.GetAxisRaw(vert)) >= deadzone)
        {
            groundMovement = true;
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
                stickAngle = stickDir * 180 / (float)System.Math.PI;
            }
        }
        else
        {
            groundMovement = false;
        }
    }

    void animationOperation()
    {
        DetStickAngle();
        ani.SetBool("groundMovement", groundMovement);
        ani.SetFloat("stickAngle", stickAngle);
    }

    // Use this for initialization
    void Start()
    {
        ani = GetComponent<Animator>();
    }

	// Update is called once per frame
	void Update()
    {
        playerMovement();
        animationOperation();
    }

    
}