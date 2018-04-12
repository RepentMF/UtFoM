using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class scr_damageEnemy : MonoBehaviour
{
    public int damage;
    private int playerDamage;
    public GameObject damageParticleEffect;
    public GameObject display;
    public Transform particleEffectSpace;
    public scr_playerStatControl player;

    private void OnTriggerEnter2D(Collider2D collision)
    {
        if (collision.gameObject.tag == "enemy")
        {
            playerDamage = damage + player.currentAtk;

            collision.gameObject.GetComponent<scr_enemyHealthControl>().damageEnemy(playerDamage);
            Instantiate(damageParticleEffect, particleEffectSpace.position, particleEffectSpace.rotation);

            var clone = (GameObject) Instantiate(display, particleEffectSpace.position, Quaternion.Euler (Vector3.zero));
            clone.GetComponent<scr_damageNumbers>().damage = playerDamage;
            clone.transform.position = particleEffectSpace.position;
        }
    }

    // Use this for initialization
    void Start ()
    {
        player = FindObjectOfType<scr_playerStatControl>();
	}
	
	// Update is called once per frame
	void Update ()
    {

	}
}
