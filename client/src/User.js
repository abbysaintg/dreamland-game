import { useEffect, useState } from "react"
import { useHistory } from "react-router-dom"

function User({ user, setUser }) {
    const [newUsername, setNewUsername] = useState("")
    const [newPassword, setNewPassword] = useState("")
    const [username, setUsername] = useState("")
    const [password, setPassword] = useState("")
    const [mode, setMode] = useState("login")
    const [passwordConfirmation, setPasswordConfirmation] = useState("")
    const [errors, setErrors] = useState([])
    let history = useHistory()

    useEffect(() => {
        const storedUser = JSON.parse(localStorage.getItem("user"))
        if (storedUser) {
            setUser(storedUser)
        }
    }, [])

    const toggleMode = () => {
        setErrors([])
        setMode(mode === "login" ? "signup" : "login")
    }

    const handleLogin = (e) => {
        e.preventDefault()
        fetch("/login", {
            method: "POST",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify({ username, password }),
        }).then((r) => {
            if (r.ok) {
                r.json().then((user) => {
                    setUser(user)
                    setUsername("")
                    setPassword("")
                    console.log(`Signed in as: ${user.username}`)
                    localStorage.setItem("user", JSON.stringify(user))
                    history.push("/me")
                })
            } else {
                r.json().then((err) => {
                    setErrors(err.errors)
                    console.log(err.errors)
                })
            }
        })

        e.target.reset()
    }

    const handleLogout = () => {
        fetch("/logout", { method: "DELETE" }).then((r) => {
            if (r.ok) {
                setUser(null)
                setMode("login")
                localStorage.removeItem("user")
                console.log("Logged out")
            }
        })
    }

    const handleNewUser = (e) => {
        e.preventDefault()
        setErrors([])
        if (newPassword !== passwordConfirmation) {
            setErrors(["Password and password confirmation must match"])
            return
        }
        fetch("/signup", {
            method: "POST",
            headers: {
                "Content-Type": "application/json",
            },
            body: JSON.stringify({
                username: newUsername,
                password: newPassword,
                password_confirmation: passwordConfirmation,
            }),
        })
            .then((r) => {
                if (r.ok) {
                    r.json().then((user) => {
                        setUser(user)
                        setNewUsername("")
                        setNewPassword("")
                        setPasswordConfirmation("")
                        localStorage.setItem("user", JSON.stringify(user))
                    })
                } else {
                    r.json().then((err) => {
                        setErrors(err.errors)
                        console.log(err.errors)
                    })
                }
            })
    }

    return (
        <div>
            {user === null ? (
                <div>
                    {mode === "login" ? (
                        <div>
                            {errors.length > 0 ? (
                                <div className='form'>
                                    <form onSubmit={handleLogin}>
                                        <div>
                                            <input type='text' id='username' autoComplete='off' placeholder='username' value={username} onChange={(e) => setUsername(e.target.value)} />
                                        </div>
                                        <div>
                                            <input type='password' id='password' placeholder='password' autoComplete='current-password' value={password} onChange={(e) => setPassword(e.target.value)} />
                                        </div>
                                    </form>
                                    <div>{errors}</div>
                                    <button onClick={() => setErrors([])}>Try again</button>
                                    <button onClick={toggleMode}>Switch to {mode === "login" ? "signup" : "login"}</button>
                                </div>
                            ) : (
                                <div className='form'>
                                    <form onSubmit={handleLogin}>
                                        <div>
                                            <input type='text' id='username' autoComplete='off' placeholder='username' value={username} onChange={(e) => setUsername(e.target.value)} />
                                        </div>
                                        <div>
                                            <input type='password' id='password' placeholder='password' autoComplete='current-password' value={password} onChange={(e) => setPassword(e.target.value)} />
                                        </div>
                                        <button type='submit'>Log In</button>
                                    </form>
                                    <button onClick={toggleMode}>Switch to {mode === "login" ? "signup" : "login"}</button>
                                </div>
                            )}
                        </div>
                    ) : (
                        <div>
                            {errors.length > 0 ? (
                                <div className='form'>
                                    <form>
                                        <div>
                                            <input type='text' id='newUsername' value={newUsername} placeholder='username' onChange={(e) => setNewUsername(e.target.value)} />
                                        </div>
                                        <div>
                                            <input type='password' id='newPassword' value={newPassword} placeholder='password' onChange={(e) => setNewPassword(e.target.value)} />
                                        </div>
                                        <div>
                                            <input type='password' id='passwordConfirmation' value={passwordConfirmation} placeholder='password confirmation' onChange={(e) => setPasswordConfirmation(e.target.value)} />
                                        </div>
                                    </form>
                                    <div>{errors}</div>
                                    <button onClick={() => setErrors([])}>Try again</button>
                                    <button onClick={toggleMode}>Switch to {mode === "login" ? "signup" : "login"}</button>
                                </div>
                            ) : (
                                <div className='form'>
                                    <form onSubmit={handleNewUser}>
                                        <div>
                                            <input type='text' id='newUsername' value={newUsername} placeholder='username' onChange={(e) => setNewUsername(e.target.value)} />
                                        </div>
                                        <div>
                                            <input type='password' id='newPassword' value={newPassword} placeholder='password' onChange={(e) => setNewPassword(e.target.value)} />
                                        </div>
                                        <div>
                                            <input type='password' id='passwordConfirmation' value={passwordConfirmation} placeholder='password confirmation' onChange={(e) => setPasswordConfirmation(e.target.value)} />
                                        </div>
                                        <button type='submit'>Sign up</button>
                                    </form>
                                    <button onClick={toggleMode}>Switch to {mode === "login" ? "signup" : "login"}</button>
                                </div>
                            )}
                        </div>
                    )}
                </div>
            ) : (
                <div className='form'>
                    <p>Welcome, {user.username}</p>
                    <button onClick={handleLogout}>Log Out</button>
                </div>
            )}
        </div>
    )
}

export default User
