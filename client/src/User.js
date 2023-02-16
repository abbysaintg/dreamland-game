import { useEffect, useState } from "react"
import { useHistory } from "react-router-dom"
import LoginForm from "./LoginForm"
import NewUserForm from "./NewUserForm"
import AuthenticatedUser from "./AuthenticatedUser"

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
            setMode(null)
            console.log(`Logged in.`)
        }
        else {
            setMode("login")
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
                    setMode("logged in")
                    setUsername("")
                    setPassword("")
                    console.log(`Logged in.`)
                    localStorage.setItem("user", JSON.stringify(user))
                    history.push("/me")
                })
            } else {
                r.json().then((err) => {
                    setErrors(err.error)
                    console.log(err.error)
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
        }).then((r) => {
            if (r.ok) {
                r.json().then((user) => {
                    setUser(user)
                    setMode("logged in")
                    setNewUsername("")
                    setNewPassword("")
                    setPasswordConfirmation("")
                    console.log("Logged in.")
                    localStorage.setItem("user", JSON.stringify(user))
                })
            } else {
                r.json().then((err) => {
                    setErrors(err.error)
                    console.log(err.error)
                })
            }
        })
    }

    return (
        <div>
            {mode === 'login' && <LoginForm handleLogin={handleLogin} setErrors={setErrors} errors={errors} username={username} setUsername={setUsername} password={password} setPassword={setPassword} toggleMode={toggleMode} />}
            {mode === 'signup' && <NewUserForm handleNewUser={handleNewUser} setErrors={setErrors} errors={errors} newUsername={newUsername} setNewUsername={setNewUsername} newPassword={newPassword} setNewPassword={setNewPassword} passwordConfirmation={passwordConfirmation} setPasswordConfirmation={setPasswordConfirmation} toggleMode={toggleMode} />}
            {user !== null && <AuthenticatedUser username={user.username} handleLogout={handleLogout} />}
        </div>
    )
}

export default User
