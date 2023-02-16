import { useState, useEffect, useRef } from "react"

function Game({ user }) {
    const [outputs, setOutputs] = useState([])
    const [input, setInput] = useState("")
    const [gameStart, setGameStart] = useState(false)
    const inputRef = useRef(null)
    const containerRef = useRef(null)
    const bottomRef = useRef(null)

    // FETCH OUTPUTS
    useEffect(() => {
        if (user != null) {
        fetch(`/users/${user.id}/gamestates`)
            .then((r) => r.json())
            .then((data) => {
                setOutputs(data)
            })}
        else {
            console.log("Not logged in.")
        }
    }, [user])

    // SUBMIT USER INPUT
    const handleKeyDown = (e) => {
        if (e.key === "Enter" && user != null) {
            if (input === "reset" || ((input === "sleep" || input === "go to sleep") && outputs[outputs.length - 1].location_id === 92)) {
                setGameStart(false)
                fetch(`/gamestates/${outputs[outputs.length - 1].id}`, {
                    method: "DELETE",
                })
                    .then((resp) => {
                        if (!resp.ok) {
                            throw new Error(`Failed to reset, status code: ${outputs.status}`)
                        }
                        return resp
                    })
                    .then(() => {
                        console.log("game reset")
                        setOutputs([outputs[0], outputs[1], outputs[2]])
                        setInput("")
                        inputRef.current.focus()
                    })
                    .catch((error) => {
                        console.error(error)
                    })
            } else if (input === "start") {
                e.preventDefault()
                setGameStart(true)
                setInput("")
            } else {
                fetch("/gamestates", {
                    method: "POST",
                    headers: {
                        "Content-Type": "application/json",
                    },
                    body: JSON.stringify({ input }),
                })
                    .then((resp) => resp.json())
                    .then((resp) => {
                        console.log(resp)
                        setOutputs([...outputs, resp])
                        setInput("")
                        inputRef.current.focus()
                    })
                    .catch((err) => console.error(err.error))
            }
        }
    }

    useEffect(() => {
        if (bottomRef.current) {
            bottomRef.current.scrollIntoView({ behavior: "smooth" })
        }
    }, [outputs])

    // REMOVE PLACEHOLDER TEXT
    const handleFocus = (event) => {
        event.target.placeholder = ""
    }

    // ADD PLACEHOLDER TEXT
    const handleBlur = (event) => {
        event.target.placeholder = "type something..."
    }

    return (
        <div className='left'>
            {gameStart === true  && user != null ? (
                <div className='outputs-container' ref={containerRef}>
                    {outputs.map((output) => (
                        <div key={output.id} ref={output.id === outputs[outputs.length - 1].id ? bottomRef : null}>
                            <div className='output-input'>{output.input ? <>&gt; {output.input}</> : null}</div>
                            <div className='output-output'>{output.output}</div>
                        </div>
                    ))}
                </div>
            ) : (
                <div className='game-start-end-container'>
                    <div className='title'>
                        <p> _______  .______       _______     ___      .___  ___.  __          ___      .__   __.  _______  </p>
                        <p>|       \ |   _  \     |   ____|   /   \     |   \/   | |  |        /   \     |  \ |  | |       \ </p>
                        <p>|  .--.  ||  |_)  |    |  |__     /  ^  \    |  \  /  | |  |       /  ^  \    |   \|  | |  .--.  |</p>
                        <p>|  |  |  ||      /     |   __|   /  /_\  \   |  |\/|  | |  |      /  /_\  \   |  . `  | |  |  |  |</p>
                        <p>|  '--'  ||  |\  \----.|  |____ /  _____  \  |  |  |  | |  `----./  _____  \  |  |\   | |  '--'  |</p>
                        <p>|_______/ | _| `._____||_______/__/     \__\ |__|  |__| |_______/__/     \__\ |__| \__| |_______/ </p>
                    </div>
                    {user != null ? <div>{gameStart === true ? (<div className="info-text">TYPE <span className="start">START</span> TO BEGIN</div>) : (<div className="info-text">TYPE <span className="start">START</span> TO RESTART</div>)}</div> : <div className="info-text">PLEASE <span className="start">LOG IN</span>  TO PLAY</div>}
                </div>
            )}
            <input className='inputs-container' type='text' placeholder='type something...' value={input} onChange={(e) => setInput(e.target.value)} onKeyDown={handleKeyDown} onFocus={handleFocus} onBlur={handleBlur} ref={inputRef} />
        </div>
    )
}

export default Game
