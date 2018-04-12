using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class scr_playerControl : MonoBehaviour
{
    public float stickX, stickY, stickDir, walkSpeed, runSpeed, hSpeed, vSpeed, deadzone,
        attackTime;
    public string hori = "Horizontal";
    public string vert = "Vertical";
    public string startName;
    private bool isAttacking, groundMovement = false;
    private static bool playerExists = false;
    private float moveSpeed, stickAngle, attackCount;
    private Animator ani;
    private Rigidbody2D body;

    // Calculations and checks for player movement speed
    void playerMovement()
    {
        // Checks to see if the player is running
        if ((Input.GetAxis("RT") > 0) || (Input.GetKey("r")))
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
        stickDir = (float) System.Math.Atan(Input.GetAxisRaw(vert) / Input.GetAxisRaw(hori));
        hSpeed = (float) System.Math.Cos(stickDir) * moveSpeed * System.Math.Sign(Input.GetAxisRaw(hori));
        vSpeed = (float) System.Math.Sin(stickDir) * moveSpeed;
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
            body.velocity = new Vector2(0f, 0f);
        }
    }

    void DetStickAngle()
    {
        if (System.Math.Abs(Input.GetAxisRaw(hori)) >= deadzone || System.Math.Abs(Input.GetAxisRaw(vert)) >= deadzone)
        {
            groundMovement = true;
            if (System.Math.Sign(Input.GetAxisRaw(hori)) > 0 && System.Math.Sign(Input.GetAxisRaw(vert)) > 0)
            {
                stickAngle = stickDir * 180 / (float) System.Math.PI;
            }
            else if (System.Math.Sign(Input.GetAxisRaw(hori)) < 0 && System.Math.Sign(Input.GetAxisRaw(vert)) > 0)
            {
                stickAngle = (stickDir * 180 / (float) System.Math.PI) + 180;
            }
            else if (System.Math.Sign(Input.GetAxisRaw(hori)) < 0 && System.Math.Sign(Input.GetAxisRaw(vert)) < 0)
            {
                stickAngle = (stickDir * 180 / (float) System.Math.PI) + 180;
            }
            else if (System.Math.Sign(Input.GetAxisRaw(hori)) > 0 && System.Math.Sign(Input.GetAxisRaw(vert)) < 0)
            {
                stickAngle = (stickDir * 180 / (float) System.Math.PI) + 360;
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
        else
        {
            groundMovement = false;
        }
    }

    void animationOperation()
    {
        if (!isAttacking)
        {
            DetStickAngle();
            ani.SetBool("groundMovement", groundMovement);
            ani.SetFloat("stickAngle", stickAngle);
        }
        
        if (Input.GetKeyDown("e"))
        {
            attackCount = attackTime;
            isAttacking = true;
        }

        if (attackCount > 0)
        {
            attackCount -= Time.deltaTime;
            body.velocity = Vector2.zero;
        }
        else
        {
            isAttacking = false;
        }
        ani.SetBool("isAttacking", isAttacking);
    }

    // Use this for initialization
    void Start()
    {
        ani = GetComponent<Animator>();
        body = GetComponent<Rigidbody2D>();

        if (!playerExists)
        {
            playerExists = true;
            DontDestroyOnLoad(transform.gameObject);
        }
        else
        {
            Destroy(gameObject);
        }
    }

	// Update is called once per frame
	void Update()
    {
        playerMovement();
        animationOperation();
    }

    
}