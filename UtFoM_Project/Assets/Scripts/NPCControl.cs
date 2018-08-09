using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class NPCControl : MonoBehaviour 
{
    public bool isSign, walking;
    public int dirX, dirY, iterator, randX, randY, size;
    public float hSpeed, moveSpeed, vSpeed, waitTime, waitTimer, walkTime, walkTimer;
    public string[] dialogue;
    public Rigidbody2D body;

    void MoveNPC()
    {
        // Still need to make NPCs able to travel in 2nd and 3rd quadrants,
        // currently can only travel in 1st and 4th
        randX = Random.Range(0, 2) * 2 - 1;
        randY = Random.Range(0, 2) * 2 - 1;
        dirX = Random.Range(-1, 2);
        dirY = Random.Range(-1, 2);
        hSpeed = (float) System.Math.Cos(dirX) * moveSpeed * randX;
        vSpeed = (float)System.Math.Sin(dirY) * moveSpeed * randY;
        body.velocity = new Vector2(hSpeed, vSpeed);
    }

	// Use this for initialization
	void Start() 
	{
        if (!isSign)
        {
            body = GetComponent<Rigidbody2D>();
            waitTime = Random.Range(3.0f, 7.0f);
            walkTime = Random.Range(2.5f, 5.0f);
            moveSpeed = 4.0f;
        }

        walking = false;
        iterator = 0;
        waitTimer = 0.0f;
        walkTimer = 0.0f;
    }
	
	// Update is called once per frame
	void Update() 
	{
		if (!isSign)
        {
            if (walking)
            {
                if (walkTimer >= walkTime)
                {
                    waitTime = Random.Range(3.0f, 7.0f);
                    walkTimer = 0.0f;
                    walking = false;
                    body.velocity = Vector2.zero;
                }
                else
                {
                    walkTimer += Time.deltaTime;
                }
            }
            else
            {
                if (waitTimer >= waitTime)
                {
                    walkTime = Random.Range(2.5f, 5.0f);
                    waitTimer = 0.0f;
                    walking = true;
                    MoveNPC();
                }
                else
                {
                    waitTimer += Time.deltaTime;
                }
            }
        }
	}
}
