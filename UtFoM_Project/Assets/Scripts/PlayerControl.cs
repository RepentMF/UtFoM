using System.Collections;
using System.Collections.Generic;
using UnityEngine.SceneManagement;
using UnityEngine;

public class PlayerControl : MonoBehaviour
{
    public bool grounded = true, moving = false, dodging = false;
    public int currentAtk, currentHealth, currentSpd, extraAtk, extraSpd, extraHealth,
       maxHealth, weaponAtk;
    public float deadzone, dodgeTime = 0.5f, dodgeTimer = 0.0f, hSpeed, moveSpeed, runSpeed,
        stickAngle, lastStickAngle, stickDir, stickX, stickY, vSpeed, walkSpeed;
    private string hori = "Horizontal", vert = "Vertical", respawnName;
    public Animator animator;
    public Rigidbody2D body;
    public SpriteRenderer sprite;
    public List<Item> inv;
    public GameObject interactable;


    void MovePlayer()
    {
        // Checks to see if the player is running or not
        if (/*(Input.GetAxis("RT") > 0) || */(Input.GetKey("r")))
        {
            moveSpeed = runSpeed;
        }
        else
        {
            moveSpeed = walkSpeed;
        }

        // Calculates correct direction and magnitude for PlayerControl movement speeds
        stickX = Input.GetAxisRaw(hori);
        stickY = Input.GetAxisRaw(vert);
        if (stickX == 0 && stickY == 0)
        {
            stickDir = 0;
            moving = false;
        }
        else
        {
            stickDir = (float)System.Math.Atan(Input.GetAxisRaw(vert) / Input.GetAxisRaw(hori));
            moving = true;
        }
        hSpeed = (float)System.Math.Cos(stickDir) * moveSpeed * System.Math.Sign(Input.GetAxisRaw(hori));
        vSpeed = (float)System.Math.Sin(stickDir) * moveSpeed;
        
        // Set Vertical Speed's numerical sign
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

    // Performs dodging operations
    void DodgePlayer()
    {
        // Changes boolean for animator
        animator.SetBool("dodging", dodging);

        // If the dodge timer is at zero
        if (dodgeTimer == 0.0f)
        {
            // Make the player dodge
            hSpeed *= 2;
            vSpeed *= 2;
            sprite.color = new Color(0f, 1f, 0f);
        }

        // Increment the dodge timer
        dodgeTimer += Time.deltaTime;

        // If the dodge timer reaches the max dodge time
        if (dodgeTimer >= dodgeTime)
        {
            // Make the player stop dodging and change the boolean for the animator
            dodgeTimer = 0.0f;
            dodging = false;
            animator.SetBool("dodging", dodging);
            hSpeed = 0f;
            vSpeed = 0f;
            sprite.color = new Color(1f, 1f, 1f);
        }
        // Apply the dodge changes to the player
        body.velocity = new Vector2(hSpeed, vSpeed);
    }

    // Determine the angle for the player's movement
    void DetermineAngle()
    {
        // Check if the stick is not in the deadzone
        if (System.Math.Abs(Input.GetAxisRaw(hori)) >= deadzone || System.Math.Abs(Input.GetAxisRaw(vert)) >= deadzone)
        {
            if (System.Math.Sign(Input.GetAxisRaw(hori)) > 0 && System.Math.Sign(Input.GetAxisRaw(vert)) > 0)
            {
                // First Quadrant
                stickAngle = stickDir * 180 / (float)System.Math.PI;
            }
            else if (System.Math.Sign(Input.GetAxisRaw(hori)) < 0 && System.Math.Sign(Input.GetAxisRaw(vert)) > 0)
            {
                // Second Quadrant
                stickAngle = (stickDir * 180 / (float)System.Math.PI) + 180;
            }
            else if (System.Math.Sign(Input.GetAxisRaw(hori)) < 0 && System.Math.Sign(Input.GetAxisRaw(vert)) < 0)
            {
                // Third Quadrant
                stickAngle = (stickDir * 180 / (float)System.Math.PI) + 180;
            }
            else if (System.Math.Sign(Input.GetAxisRaw(hori)) > 0 && System.Math.Sign(Input.GetAxisRaw(vert)) < 0)
            {
                // Fourth Quadrant
                // Running dodge works here
                stickAngle = (stickDir * 180 / (float)System.Math.PI) + 360;
            }
            else if (Input.GetAxisRaw(hori) == 0 && System.Math.Sign(Input.GetAxisRaw(vert)) == 1)
            {
                // 90 Degrees
                stickAngle = 90;
            }
            else if (System.Math.Sign(Input.GetAxisRaw(hori)) == -1 && Input.GetAxisRaw(vert) == 0)
            {
                // 180 Degrees
                stickAngle = 180;
            }
            else if (Input.GetAxisRaw(hori) == 0 && System.Math.Sign(Input.GetAxisRaw(vert)) == -1)
            {
                // 270 Degrees
                // Running dodge works here
                stickAngle = 270;
            }
            else
            {
                // 0 or 360 Degrees                
                // Running dodge works here
                stickAngle = stickDir * 180 / (float) System.Math.PI;
            }
            // Sets lastStickAngle to stickAngle, in case stickAngle changes but you need to use a previous 
            // frame's stickAngle
            lastStickAngle = stickAngle;
        }
    }

    void AnimatePlayer()
    {
        // Change animator booleans
        animator.SetBool("grounded", grounded);
        animator.SetBool("moving", moving);
        if (moving)
        {
            DetermineAngle();
            animator.SetFloat("stickAngle", stickAngle);
        }
        else
        {
            animator.SetFloat("stickAngle", lastStickAngle);
        }
    }

    void OnTriggerEnter2D(Collider2D collision)
    {
        // If colliding with an interactable, tell the game you are
        if (collision.CompareTag("Interactable"))
        {
            interactable = collision.gameObject;
        }
    }

    void OnTriggerExit2D(Collider2D collision)
    {
        // If no longer colliding with an interactable, the game you aren't
        if (collision.CompareTag("Interactable"))
        {
            if (collision.gameObject == interactable)
            {
                interactable = null;
            }
        }
    }

    void AddItem(Item item)
    {
        // Adds an item to the player's inventory
        for (int i = 0; i < inv.Capacity; i++)
        {
            if (inv[i] == null)
            {
                inv[i] = item;
                break;
            }
        }
    }

    // Use this for initialization
    void Start() 
	{
        // Sets up the game
        animator = GetComponent<Animator>();
        body = GetComponent<Rigidbody2D>();
        sprite = GetComponent<SpriteRenderer>();

        if (SceneManager.GetActiveScene().name == "Main")
        {
            // Sets up player's first direction and speeds
            walkSpeed = currentSpd;
            runSpeed = currentSpd * 1.5f;
            lastStickAngle = 270;
        }
	}

    // Update is called once per frame
    void Update()
    {
        if (SceneManager.GetActiveScene().name == "Main")
        {
            // Check if the player is not dodging
            if (!dodging)
            {
                MovePlayer();
                AnimatePlayer();

                // Check if the player tries to interact with something
                if (Input.GetKeyDown("e") && interactable != null)
                {
                    if (interactable.GetComponent<Item>())
                    {
                        inv.Add(interactable.GetComponent<Item>());
                        interactable.gameObject.SetActive(false);
                    }
                }
                // Then check if the player tries to dodge
                else if (Input.GetKeyDown("f"))
                {
                    dodging = true;
                }
            }
            else
            {
                // Make player dodge
                DodgePlayer();
            }
        }
    }
}