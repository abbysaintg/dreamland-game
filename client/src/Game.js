import { useState, useEffect, useRef } from "react"

function Game() {
    const [outputs, setOutputs] = useState([])
    const [text, setText] = useState("")
    const inputRef = useRef(null)

    // FETCH OUTPUTS
    useEffect(() => {
        fetch("/outputs")
            .then((r) => r.json())
            .then((data) => setOutputs(data))
    }, [])
    
    // SUBMIT USER TEXT
    const handleKeyDown = (e) => {
        if (e.key === "Enter") {
            fetch('/outputs', {
                method: 'POST',
                headers: {
                  'Content-Type': 'application/json'
                },
                body: JSON.stringify({ text })
            })
            .then((response) => response.json())
            .then((data) => {
                setOutputs([...outputs, data])
                setText("")
                inputRef.current.focus()
            })
            .catch((error) => console.error('Error:', error));
        }
    }

    // REMOVE PLACEHOLDER TEXT
    const handleFocus = (event) => {
        event.target.placeholder = ""
    }

    // ADD PLACEHOLDER TEXT
    const handleBlur = (event) => {
        event.target.placeholder = "type something..."
    }

    return (
        <div className='game-container'>
            <div className='outputs-container'>
                {outputs.map((output) => (
                    <div key={output.id} className='output'>
                        {output.text}
                    </div>
                ))}
            </div>
            <input className='inputs-container' type='text' placeholder='type something...' value={text} onChange={(e) => setText(e.target.value)} onKeyDown={handleKeyDown} onFocus={handleFocus} onBlur={handleBlur}  ref={inputRef}/>
        </div>
    )
}

export default Game
