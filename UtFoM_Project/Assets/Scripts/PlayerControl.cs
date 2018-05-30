using System.Collections;
using System.Collections.Generic;
using UnityEngine.SceneManagement;
using UnityEngine;

public class PlayerControl : MonoBehaviour
{
    public bool dodging = false, grounded = true, moving = false, running = false;
    public int currentAtk, currentHealth, currentSpd, maxStm = 9, weaponAtk;
    public float cripple = -9.0f, crippleTimer, crippleSpd, currentStm, deadzone, dodgeTime = 0.5f, 
        dodgeTimer = 0.0f, dodgeSpeed, dodgeSpeedH, dodgeSpeedV, hSpeed, moveSpeed, 
        runSpeed, stickAngle, lastStickAngle, runTime = 1.0f, stickDir, stickX, stickY, vSpeed, walkSpeed;
    private string hori = "Horizontal", vert = "Vertical", respawnName;
    public Animator animator;
    public Rigidbody2D body;
    public SpriteRenderer sprite;
    public Item quickItem;
    public List<Item> inv;
    public GameObject interactable;


    void MovePlayer()
    {
        // Checks to see if the player is running or not
        if (running)
        {
            moveSpeed = runSpeed;
        }
        else if (currentStm == -1)
        {
            moveSpeed = crippleSpd;
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
        }
        else
        {
            stickDir = (float)System.Math.Atan(Input.GetAxisRaw(vert) / Input.GetAxisRaw(hori));
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

        // Make sure player is "moving"
        if (Mathf.Abs(hSpeed) > 0 || Mathf.Abs(vSpeed) > 0)
        {
            moving = true;
        }
        else
        {
            moving = false;
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
            dodgeSpeedH = (float)System.Math.Cos(stickDir) * dodgeSpeed * System.Math.Sign(Input.GetAxisRaw(hori));
            dodgeSpeedV = (float)System.Math.Sin(stickDir) * dodgeSpeed;
            if (Input.GetAxisRaw(hori) < 0 && Input.GetAxisRaw(vert) < 0)
            {
                dodgeSpeedV *= System.Math.Sign(Input.GetAxisRaw(vert));
            }
            else if (Input.GetAxisRaw(hori) < 0 && Input.GetAxisRaw(vert) > 0)
            {
                dodgeSpeedV *= -1;
            }
            body.velocity = new Vector2(dodgeSpeedH, dodgeSpeedV);
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
            grounded = true;
            animator.SetBool("dodging", dodging);
            hSpeed = 0f;
            vSpeed = 0f;
            body.velocity = new Vector2(hSpeed, vSpeed);
            sprite.color = new Color(1f, 1f, 1f);
        }
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
                stickAngle = 270;
            }
            else
            {
                // 0 or 360 Degrees
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
            // Sets up player's first stats and direction
            currentSpd = 10;
            walkSpeed = currentSpd;
            crippleSpd = currentSpd * 0.6f;
            runSpeed = currentSpd * 1.5f;
            dodgeSpeed = currentSpd * 1.75f;
            lastStickAngle = 270;

            maxStm = 9;
            currentStm = maxStm;
            cripple = -9.0f;
            dodgeTime = 0.5f;
            runTime = 1.0f;
        }
	}

    // Update is called once per frame
    void Update()
    {
        if (SceneManager.GetActiveScene().name == "Main")
        {
            if (/*(Input.GetAxis("RT") > 0) || */(Input.GetKeyDown("r")))
            {
                if (running)
                {
                    running = false;
                }
                else
                {
                    running = true;
                }
            }

            // Check if the player is not dodging
            if (!dodging && grounded)
            {
                MovePlayer();
                AnimatePlayer();
                
                if (running && moving && currentStm >= 0)
                {
                    crippleTimer = cripple;

                    currentStm -= Time.deltaTime;
                }
                else if (currentStm < 0)
                {
                    currentStm = -1;
                    running = false;
                    crippleTimer += Time.deltaTime;
                    if (crippleTimer >= runTime)
                    {
                        currentStm = maxStm;
                        crippleTimer = cripple;
                    }
                }
                else if (currentStm < maxStm)
                {
                    crippleTimer = cripple;

                    currentStm += Time.deltaTime;
                    if (currentStm > maxStm)
                    {
                        currentStm = maxStm;
                    }
                }

                // Check if the player tries to interact with something
                if (Input.GetKeyDown("e") && interactable != null)
                {
                    if (interactable.GetComponent<Item>())
                    {
                        inv.Add(interactable.GetComponent<Item>());
                        interactable.gameObject.SetActive(false);
                    }
                }
                // Then check if the player tries to dodge or jump
                else if (Input.GetKeyDown("f") && currentStm > 0)
                {
                    // Dodge here
                    dodging = true;
                    currentStm -= 3;
                    if (currentStm < 0)
                    {
                        currentStm = -1;
                    }
                }
                else if (Input.GetKeyDown("j") && currentStm > 0)
                {
                    // Jump here
                    grounded = false;
                    currentStm -= 3;
                    if (currentStm < 0)
                    {
                        currentStm = -1;
                    }
                }
                else if (Input.GetKeyDown("i"))
                {
                    // Use shortcut item here
                    if (quickItem != null)
                    {
                        //quickItem.Use();
                    }
                }
            }
            else
            {
                // Make player dodge or jump
                DodgePlayer();
            }
        }
    }
}