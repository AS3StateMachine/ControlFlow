package flow.impl
{
import flow.impl.support.ClassRegistry;
import flow.impl.support.cmds.MockCommandOne;
import flow.impl.support.cmds.MockCommandThree;
import flow.impl.support.cmds.MockCommandTwo;
import flow.impl.support.guards.GrumpyGuard;
import flow.impl.support.guards.HappyGuard;
import flow.impl.support.guards.JoyfulGuard;

import org.hamcrest.assertThat;
import org.hamcrest.collection.array;
import org.hamcrest.object.equalTo;
import org.hamcrest.object.strictlyEqualTo;
import org.swiftsuspenders.Injector;

public class SimpleControlFlowTest implements ClassRegistry
{
    private var _classUnderTest:SimpleControlFlow;
    private var _injector:Injector;
    private var _parent:ControlFlowContainer;
    private var _executor:Executor;
    private var _registeredClasses:Vector.<Class>;

    [Before]
    public function before():void
    {
        _registeredClasses = new Vector.<Class>();
        _injector = new Injector();
        _injector.map( ClassRegistry ).toValue( this );
        _parent = new ControlFlowContainer( _injector );
        _executor = new Executor( _injector );
        _classUnderTest = new SimpleControlFlow( _parent, _executor );

    }

    [Test]
    public function and_property_returns_parent_mapping():void
    {
        assertThat( _classUnderTest.and, strictlyEqualTo( _parent ) );
    }

    [Test]
    public function execute_returns_self():void
    {
        assertThat( _classUnderTest.executeAll(), strictlyEqualTo( _classUnderTest ) );
    }

    [Test]
    public function execute_maps_command_classes_to_CommandMap_and_retains_order():void
    {
        _classUnderTest.executeAll( MockCommandOne, MockCommandThree, MockCommandTwo )
        assertThat( _classUnderTest._commandGroup.commands,
                array(
                        strictlyEqualTo( MockCommandOne ),
                        strictlyEqualTo( MockCommandThree ),
                        strictlyEqualTo( MockCommandTwo )
                ) );
    }

    [Test]
    public function onApproval_returns_self():void
    {
        assertThat( _classUnderTest.onApproval(), strictlyEqualTo( _classUnderTest ) );
    }

    [Test]
    public function onApproval_maps_guard_classes_to_CommandMap_and_retains_order():void
    {
        _classUnderTest.onApproval( GrumpyGuard, HappyGuard, JoyfulGuard )
        assertThat( _classUnderTest._commandGroup.guards,
                array(
                        strictlyEqualTo( GrumpyGuard ),
                        strictlyEqualTo( HappyGuard ),
                        strictlyEqualTo( JoyfulGuard )
                ) );
    }

    [Test]
    public function execute_executes_commandGroup():void
    {
        _classUnderTest.executeAll( MockCommandOne );
        _classUnderTest.execute();
        assertThat( _registeredClasses.length, equalTo( 1 ) );
    }

    public function register( c:Class ):void
    {
        _registeredClasses.push( c );
    }
}
}
