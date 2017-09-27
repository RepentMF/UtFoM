using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class obj_player_controller : MonoBehaviour
{
    public float stickDir, walkSpeed, runSpeed, hSpeed, vSpeed, deadzone;
    private float moveSpeed, stickAngle;
    private bool quad1And4Bool, quad1And2Bool, quad2And3Bool, quad3And4Bool;
    public string hori = "Horizontal";
    public string vert = "Vertical";
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
        stickDir = (float)System.Math.Atan(Input.GetAxisRaw(vert) / Input.GetAxisRaw(hori));
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
        if (System.Math.Abs(Input.GetAxisRaw(hori)) > deadzone || System.Math.Abs(Input.GetAxisRaw(vert)) > deadzone)
        {
            transform.Translate(new Vector2(hSpeed, vSpeed));
        }
    }

    void DetStickAngle(float stickDir)
    {
        if (System.Math.Abs(Input.GetAxisRaw(hori)) > deadzone || System.Math.Abs(Input.GetAxisRaw(vert)) > deadzone)
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
            else if (Input.GetAxisRaw(hori) == 0 && Input.GetAxisRaw(vert) == 1)
            {
                stickAngle = 90;
            }
            else if (Input.GetAxisRaw(hori) == -1 && Input.GetAxisRaw(vert) == 0)
            {
                stickAngle = 180;
            }
            else if (Input.GetAxisRaw(hori) == 0 && Input.GetAxisRaw(vert) == -1)
            {
                stickAngle = 270;
            }
            else
            {
                stickAngle = stickDir * 180 / (float)System.Math.PI;
            }
        }

        if (stickAngle < 45 || stickAngle > 315)
        {
            quad1And4Bool = true;
            quad1And2Bool = false;
            quad2And3Bool = false;
            quad3And4Bool = false;
        }
        else if (stickAngle > 45 && stickAngle < 135)
        {
            quad1And4Bool = false;
            quad1And2Bool = true;
            quad2And3Bool = false;
            quad3And4Bool = false;
        }
        else if (stickAngle > 135 && stickAngle < 225)
        {
            quad1And4Bool = false;
            quad1And2Bool = false;
            quad2And3Bool = true;
            quad3And4Bool = false;
        }
        else if (stickAngle > 225 && stickAngle < 315)
        {
            quad1And4Bool = false;
            quad1And2Bool = false;
            quad2And3Bool = false;
            quad3And4Bool = true;
        }

        if (System.Math.Abs(Input.GetAxisRaw(hori)) < deadzone && System.Math.Abs(Input.GetAxisRaw(vert)) < deadzone)
        {
            quad1And4Bool = false;
            quad1And2Bool = false;
            quad2And3Bool = false;
            quad3And4Bool = false;
        }
    }

    void animationOperation()
    {
        DetStickAngle(stickDir);
        ani.SetFloat("stickAngle", stickAngle);
        ani.SetBool("quad1And4Angle", quad1And4Bool);
        ani.SetBool("quad1And2Angle", quad1And2Bool);
        ani.SetBool("quad2And3Angle", quad2And3Bool);
        ani.SetBool("quad3And4Angle", quad3And4Bool);
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