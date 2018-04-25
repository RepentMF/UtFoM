using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MainCameraControl : MonoBehaviour 
{
    private static bool exists = false;
    private Vector3 targetPosition;
    public float moveSpeed;
    public GameObject target;

	// Use this for initialization
	void Start () 
	{
        DontDestroyOnLoad(transform.gameObject);

        if (!exists)
        {
            exists = true;
            DontDestroyOnLoad(transform.gameObject);
        }
        else
        {
            Destroy(gameObject);
        }
	}
	
	// Update is called once per frame
	void Update () 
	{
        targetPosition = new Vector3(target.transform.position.x, target.transform.position.y,
            transform.position.z);
        transform.position = Vector3.Lerp(transform.position, targetPosition, moveSpeed * Time.deltaTime);
	}
}
