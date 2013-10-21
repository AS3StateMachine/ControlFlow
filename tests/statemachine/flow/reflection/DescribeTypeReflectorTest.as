package statemachine.flow.reflection
{
import org.hamcrest.assertThat;
import org.hamcrest.object.instanceOf;
import org.hamcrest.object.isFalse;
import org.hamcrest.object.isTrue;

import statemachine.flow.impl.support.cmds.AsyncCmd;
import statemachine.support.cmds.MockCommandOne;
import statemachine.support.guards.OnlyIfGoodbye;

public class DescribeTypeReflectorTest
{
    private var _classUnderTest:DescribeTypeReflector;


    [Before]
    public function before():void
    {
        _classUnderTest = new DescribeTypeReflector();
    }

    [Test]
    public function describe_returns_instanceOf_TypeDescription():void
    {
        assertThat( _classUnderTest.describe( OnlyIfGoodbye ), instanceOf( TypeDescription ) );
    }

    [Test]
    public function when_type_has_approve_method_hasApproveMethod_returns_true():void
    {
        assertThat( _classUnderTest.describe( OnlyIfGoodbye ).hasApproveMethod, isTrue() );
    }

    [Test]
    public function when_type_does_not_have_approve_method_hasApproveMethod_returns_false():void
    {
        assertThat( _classUnderTest.describe( MockCommandOne ).hasApproveMethod, isFalse() );
    }

    [Test]
    public function when_type_has_execute_method_hasExecuteMethod_returns_true():void
    {
        assertThat( _classUnderTest.describe( MockCommandOne ).hasExecuteMethod, isTrue() );
    }

    [Test]
    public function when_type_does_not_have_execute_method_hasExecuteMethod_returns_false():void
    {
        assertThat( _classUnderTest.describe( OnlyIfGoodbye ).hasExecuteMethod, isFalse() );
    }

    [Test]
    public function when_type_has_async_execute_method_hasAsyncMethod_returns_true():void
    {
        assertThat( _classUnderTest.describe( AsyncCmd ).hasAsyncExecuteMethod, isTrue() );
    }

    [Test]
    public function when_type_does_not_have_async_execute_method_hasAsyncMethod_returns_false():void
    {
        assertThat( _classUnderTest.describe( MockCommandOne ).hasAsyncExecuteMethod, isFalse() );
    }


}
}
