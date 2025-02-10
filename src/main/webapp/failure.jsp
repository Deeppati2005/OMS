<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>FAILURE PAGE</title>
    <style>
        body {
            margin: 0;
            padding: 0;
            font-family: Arial, sans-serif;
            display: flex;
            align-items: center;
            justify-content: center;
            min-height: 100vh;
            background-color: #f8d7da;
            color: #721c24;
        }

        .container {
            text-align: center;
            background-color: #f5c6cb;
            padding: 2rem;
            border: 1px solid #f5c6cb;
            border-radius: 8px;
            box-shadow: 0px 4px 12px rgba(0, 0, 0, 0.1);
            max-width: 400px;
            width: 90%;
        }

        .container h1 {
            font-size: 2.5rem;
            margin-bottom: 1rem;
        }

        .container p {
            font-size: 1.2rem;
            margin-bottom: 1.5rem;
        }

        .container button {
            padding: 0.7rem 1.5rem;
            background-color: #721c24;
            color: white;
            border: none;
            border-radius: 4px;
            font-size: 1rem;
            cursor: pointer;
        }

        .container button:hover {
            background-color: #5a1d1f;
        }

        @media screen and (max-width: 768px) {
            .container h1 {
                font-size: 2rem;
            }

            .container p {
                font-size: 1rem;
            }

            .container button {
                padding: 0.6rem 1.2rem;
            }
        }

        @media screen and (max-width: 480px) {
            .container h1 {
                font-size: 1.8rem;
            }

            .container p {
                font-size: 0.9rem;
            }

            .container button {
                padding: 0.5rem 1rem;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>Failure</h1>
        <p>Sorry, an error occurred while processing your request.
        <br><br>
        <%
        String s1=(String)session.getAttribute("email");
        out.println("FAILURE: " + s1);
    	%>
        </p>
        <button onclick="goBack()">Go Back</button>
        <script>
            function goBack() {
                window.history.back();
            }
        </script>
    </div> 
</body>
</html>
