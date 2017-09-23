using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class obj_player_controller : MonoBehaviour
{
    public float moveSpeed;
    public string hori = "Horizontal";
    public string vert = "Vertical";

    // Use this for initialization
    void Start()
    {
        
	}
	
	// Update is called once per frame
	void Update ()
    {
        if (Input.GetAxisRaw(hori) > 0.5f || Input.GetAxisRaw(hori) < -0.5f)
        {
            transform.Translate(new Vector3(Input.GetAxisRaw(hori) * moveSpeed * Time.deltaTime, 0f, 0f));
        }

        if (Input.GetAxisRaw(vert) > 0.5f || Input.GetAxisRaw(vert) < -0.5f)
        {
            transform.Translate(new Vector3(0f, Input.GetAxisRaw(vert) * moveSpeed * Time.deltaTime, 0f));
        }
    }
}