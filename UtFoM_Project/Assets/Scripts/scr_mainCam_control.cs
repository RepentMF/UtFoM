using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class scr_mainCam_control : MonoBehaviour
{
    public float moveSpeed;
    public GameObject followTarget;
    private Vector3 targetPosition;

	// Use this for initialization
	void Start ()
    {
	}
	
	// Update is called once per frame
	void Update ()
    {
        targetPosition = new Vector3(followTarget.transform.position.x, followTarget.transform.position.y,
           transform.position.z);
        transform.position = Vector3.Lerp(transform.position, targetPosition, moveSpeed * Time.deltaTime);
    }
}
