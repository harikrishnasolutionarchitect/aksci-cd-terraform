from flask import Flask, render_template
import random

app = Flask(__name__)

# list of cat images
images = [
    "https://colorlib.com/wp/wp-content/uploads/sites/2/free-html5-and-css3-login-forms.jpg.webp"
]

@app.route('/')
def index():
    url = random.choice(images)
    return render_template('index.html', url=url)


if __name__ == "__main__":
    app.run(host="0.0.0.0")
