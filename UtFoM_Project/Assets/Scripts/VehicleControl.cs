using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class VehicleControl : MonoBehaviour 
{
    public float hSpeed, vSpeed;
    public Vector2 position;
    public Rigidbody2D body;

    public void MoveVehicle(float hSpeed, float vSpeed)
    {
        this.hSpeed = hSpeed;
        this.vSpeed = vSpeed;
    }

    public void OnCollisionEnter2D(Collision2D collision)
    {

    }

    public void OnCollisionExit2D(Collision2D collision)
    {

    }

    // Use this for initialization
    void Start () 
	{
        hSpeed = 0f;
        vSpeed = 0f;
        body = GetComponent<Rigidbody2D>();
        position = body.position;
    }

    // Update is called once per frame
    void Update () 
	{
        position = body.position;
        body.velocity = new Vector2(hSpeed, vSpeed);
    }
}