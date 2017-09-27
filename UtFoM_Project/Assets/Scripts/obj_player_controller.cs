using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class obj_player_controller : MonoBehaviour
{
    public float stickDir, walkSpeed, runSpeed, hSpeed, vSpeed, deadzone;
    public float moveSpeed;
    public string hori = "Horizontal";
    public string vert = "Vertical";

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

    // Use this for initialization
    void Start()
    {
    }

	// Update is called once per frame
	void Update()
    {
        playerMovement();
    }

    
}