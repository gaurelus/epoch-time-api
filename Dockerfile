# Use an official Python runtime as a parent image
FROM python:3.8-slim-buster

# Set the working directory in the container to /app
WORKDIR /app

# Add the app directory contents into the container at /app
ADD ./app /app

# Copy the requirements.txt file into the container
COPY requirements.txt .

# Install any needed packages specified in requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# Make port 80 available to the world outside this container
EXPOSE 80

# Run main.py when the container launches
CMD ["python", "-m", "flask", "run", "--host=0.0.0.0", "--port=80"]
