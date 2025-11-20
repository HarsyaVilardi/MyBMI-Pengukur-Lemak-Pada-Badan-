package com.harsya.mybmi

import android.content.Intent
import android.os.Bundle
import androidx.appcompat.app.AppCompatActivity
import com.google.android.material.snackbar.Snackbar
import com.harsya.mybmi.databinding.ActivityMainBinding
import java.math.BigDecimal
import java.math.RoundingMode

class MainActivity : AppCompatActivity() {

    private lateinit var binding: ActivityMainBinding

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        binding = ActivityMainBinding.inflate(layoutInflater)
        setContentView(binding.root)

        // Optional: set icon
        supportActionBar?.setIcon(R.drawable.logo)
        supportActionBar?.setDisplayShowHomeEnabled(true)

        binding.calculateBtn.setOnClickListener {
            val heightTxt = binding.heightEDTX.text.toString()
            val weightTxt = binding.weightEDTX.text.toString()

            if (heightTxt.isNotEmpty() && weightTxt.isNotEmpty()) {
                val weight = weightTxt.toDouble()
                val height = heightTxt.toDouble() / 100

                if (weight > 0 && weight < 600 && height >= 0.50 && height < 2.50) {

                    val intent = Intent(this, ResultActivity::class.java)
                    intent.putExtra("bmi", calculateBMI(weight, height))
                    startActivity(intent)

                } else {
                    showErrorSnack("Incorrect Values")
                }

            } else {
                showErrorSnack("A field is missing")
            }
        }
    }

    private fun showErrorSnack(message: String) {
        val snackbar = Snackbar.make(binding.container, "error : $message !", Snackbar.LENGTH_LONG)
        snackbar.view.setBackgroundResource(R.color.colorRed)
        snackbar.show()
    }

    private fun calculateBMI(weight: Double, height: Double): Double {
        return BigDecimal(weight / (height * height))
            .setScale(2, RoundingMode.HALF_EVEN)
            .toDouble()
    }
}
